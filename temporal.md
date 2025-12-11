# Temporal

Temporal is a runtime for durable function executions called workflow executions. By **durable execution**, we mean:

- Workflow execution state and progress are tracked,
- If execution fails at a particular step, we can safely resume execution where we left off.

This is achieved with an _event history_ where the state of a workflow is tracked at each step.

## Architecture

A Temporal platform consists of a "Temporal service" (a server, typically running as a cluster) and the workflow processes that defined by applications and run on the cluster.

At a high level:

```
┌────────────────────────────┐
│                            │
│  ┌──────────────────────┐  │
│  │   Temporal client    │  │
│  │                      │  │
│  └──────────────────────┘  │
└────┬────────────────▲──────┘
     │                │
     │                │
┌────▼────────────────┴──────┐
│                            │
│      Temporal cluster      │
│                            │
│                            │
└──┬──▲─────┬──▲─────┬─▲─────┘
   │  │     │  │     │ │
   │  │     │  │     │ │
 ┌─▼──┼─┐ ┌─▼──┼─┐ ┌─▼─┼─┐
 │      │ │      │ │     │
 │      │ │      │ │     │
 │      │ │      │ │     │
 └──────┘ └──────┘ └─────┘

  Worker Processes running workflows
```

## Workflows

A Temporal application is a set of _workflow_ executions. Each workflow execution has its own state, runs concurrently with other workflows, and communicates with other workflow executions.

A workflow execution is a **reentrant process**. This is defined as a process that is:

- _Resumable_: the process can resume after waiting for something.
- _Recoverable_: the process can restart where it left off if it failed.
- _Reactive_: the process can react to external events.

This provides a behavior guarantee that a once triggered, a workflow execution _will eventually complete_ whether that takes seconds or much longer.

What a workflow actual does is defined by a _workflow definition_, which you write in your application code.

## Workflow definitions

A workflow definition is a system of steps, written in ordinary applicaton code. This defines what should actually happen during a workflow execution. Temporal's SDK supports a number of programming languages.

Each workflow is made up of **activities**, which define discrete steps in the workflow. While called activities within a workflow _definition_, during workflow execution they are called **tasks**.

### Example definition

In the example below, we'll define some activities for completing a bank withdrawal and deposit.

First, define an activity for withdrawing money:

```typescript
import type { PaymentDetails } from "./shared";
import { BankingService } from "./banking-client";

export async function withdraw(details: PaymentDetails): Promise<string> {
  console.log(
    `Withdrawing $${details.amount} from account ${details.sourceAccount}.\n\n`
  );
  const bank1 = new BankingService("bank1.example.com");
  return await bank1.withdraw(
    details.sourceAccount,
    details.amount,
    details.referenceId
  );
}
```

For depositing money:

```typescript
export async function deposit(details: PaymentDetails): Promise<string> {
  console.log(
    `Depositing $${details.amount} into account ${details.targetAccount}.\n\n`
  );
  const bank2 = new BankingService("bank2.example.com");
  return await bank2.deposit(
    details.targetAccount,
    details.amount,
    details.referenceId
  );
}
```

And for refunding money:

```typescript
export async function refund(details: PaymentDetails): Promise<string> {
  console.log(
    `Refunding $${details.amount} to account ${details.sourceAccount}.\n\n`
  );
  const bank1 = new BankingService("bank1.example.com");
  return await bank1.deposit(
    details.sourceAccount,
    details.amount,
    details.referenceId
  );
}
```

Separating workflow steps into discrete activities is important. As an activity, each step can be retried. It also makes it easier to minimize changes to your overall workflow definition, which has [deterministic constraints](#deterministic-contraints). As a general rule, **all business logic should be defined in activities**, and your workflow definition should only tie together these steps.

With our activities defined, we can tie them together as a workflow definition:

```typescript
import { proxyActivities } from "@temporalio/workflow";
import { ApplicationFailure } from "@temporalio/common";

import type * as activities from "./activities";
import type { PaymentDetails } from "./shared";

export async function moneyTransfer(details: PaymentDetails): Promise<string> {
  // Get the Activities for the Workflow and set up the Activity Options.
  const { withdraw, deposit, refund } = proxyActivities<typeof activities>({
    // RetryPolicy specifies how to automatically handle retries if an Activity fails.
    retry: {
      initialInterval: "1 second",
      maximumInterval: "1 minute",
      backoffCoefficient: 2,
      maximumAttempts: 500,
      nonRetryableErrorTypes: ["InvalidAccountError", "InsufficientFundsError"],
    },
    startToCloseTimeout: "1 minute",
  });

  // Execute the withdraw Activity
  let withdrawResult: string;
  try {
    withdrawResult = await withdraw(details);
  } catch (withdrawErr) {
    throw new ApplicationFailure(`Withdrawal failed. Error: ${withdrawErr}`);
  }

  // Execute the deposit Activity
  let depositResult: string;
  try {
    depositResult = await deposit(details);
  } catch (depositErr) {
    // The deposit failed; try to refund the money.
    let refundResult;
    try {
      refundResult = await refund(details);
      throw ApplicationFailure.create({
        message: `Failed to deposit money into account ${details.targetAccount}. Money returned to ${details.sourceAccount}. Cause: ${depositErr}.`,
      });
    } catch (refundErr) {
      throw ApplicationFailure.create({
        message: `Failed to deposit money into account ${details.targetAccount}. Money could not be returned to ${details.sourceAccount}. Cause: ${refundErr}.`,
      });
    }
  }
  return `Transfer complete (transaction IDs: ${withdrawResult}, ${depositResult})`;
}
```

Finally, you use the temporal client to trigger a workflow execution using your definition:

```typescript
import { Connection, Client } from "@temporalio/client";
import { moneyTransfer } from "./workflows";
import type { PaymentDetails } from "./shared";

import { namespace, taskQueueName } from "./shared";

async function run() {
  const connection = await Connection.connect();
  const client = new Client({ connection, namespace });

  const details: PaymentDetails = {
    amount: 400,
    sourceAccount: "85-150",
    targetAccount: "43-812",
    referenceId: "12345",
  };

  console.log(
    `Starting transfer from account ${details.sourceAccount} to account ${details.targetAccount} for $${details.amount}`
  );

  const handle = await client.workflow.start(moneyTransfer, {
    args: [details],
    taskQueue: taskQueueName,
    workflowId: "pay-invoice-801",
  });

  console.log(
    `Started Workflow ${handle.workflowId} with RunID ${handle.firstExecutionRunId}`
  );
  console.log(await handle.result());
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
```

### Tracking workflow state

The temporal cluster surfaces a web UI you can use to see details about running workflows and their current states.

To determine the result of a workflow from your application code, call `result` on the returned `handle` object:

```typescript
const handle = await client.workflow.start(example, {
  args: [user],
  taskQueue: "ejson",
  workflowId: `example-user-${user.id}`,
});

const result: Result = await handle.result();
```

Note that the `Result` type is determined by your workflow definition and its return type.

If you want to determine the high-level status of a workflow (e.g. `RUNNING`, `COMPLETED`, `FAILED`, `TERMINATED`), you can query the client using the workflow's ID:

```typescript
import { Connection, WorkflowClient } from "@temporalio/client";

async function describeWorkflow(workflowId: string, runId?: string) {
  const connection = await Connection.connect(); // Connect to Temporal server
  const client = new WorkflowClient(connection);

  // Get a handle for the specific workflow execution
  const handle = client.getHandle(workflowId, runId);

  // Call the describe method
  const description = await handle.describe();

  // The 'description' object (type WorkflowExecutionInfo) contains details like status, start time, etc.
  console.log(`Workflow Status: ${description.status}`);
  console.log(`Pending Activities:`, description.pendingActivities);

  return description;
}
```

### Errors in workflows

An error in workflow execution can either cause a **task failure** (failure at activity level) or a **workflow execution failure** (failure at workflow level).

Task failures typically occur when a running activity throws an exception or panics. These types of failures will cause the task to be retried, depending on the retry strategy you defined.

Workflow failures are usually thrown by the Temporal service itself, for example if a workflow is cancelled. However, you can signal that an entire workflow should fail by throwing an [`ApplicationError`](https://docs.temporal.io/references/failures#application-failure) type in your activity code.

### Deterministic constraints

A critical aspect of workflow definitions is they must be **deterministic** – in a workflow context, this means you must ensure that any time your workflow is executed it makes _the same workflow API calls_ in the _same order_.

Generally this means that it is unsafe to make changes to workflow definitions that produce side effects in workflow execution (called _commands_). When a workflow's code replays, the commands that are emitted are compared with the existing event history. If a corresponding event already exists within the event history that matches that command, then execution continues. _However_, if a generated command doesn't match what is expected in the existing event history, the workflow execution returns a _non-deterministic error_.

Typically there are two reasons why a command might be generated out of sequence, or the wrong command might be generated altogether:

1. Code changes are made to a workflow definition that is in use by a running workflow execution.2. There is intrinsic non-deterministic logic (such as inline random branching).

This is why it's critical that workflow definitions be "thin", and all business logic is isolated within its activities.

This is a simplified overview of the problem, for a deeper explanation of deterministic constraints, read [the official documentation](https://docs.temporal.io/workflow-definition?basic-workflow-definition=typescript#deterministic-constraints).

You can work around deterministic constraints by [versioning](https://docs.temporal.io/production-deployment/worker-deployments/worker-versioning) your workflows so you can safely roll out breaking changes to your definitions.
