Agent Runtime
=============

This document briefly describes the "agent runtime" as it currently (as of October 26th, 2026) works at Lattice.

Briefly describes, the agent runtime abstracts the implementation of agentic workflows so product teams can build them without requiring a deep understanding of runtime internals. It also provides a single point of leverage to introduce new capabilities, like agent memory.

Usage
-----

Teams define an `AgentProfile`, which is a configuration object that provides:

1. The initial prompt for the agent,
2. A list of the tools and skills available to it, pulled from our registries,
3. A few other configuration details that govern how the agent will run.

Together with initial data about the current session, this profile is used to build a `RuntimeSession`:

```typescript
const session = await this.agentRuntime.materializeSession('profile_name', sessionContext);
```

Under the hood, the agent run time uses the profile and initial session context to materialize all the information needed to run the agent: information about the current end-user and their permissions, information about the workflow as defined in the profile, and so on. With this information, it uses the [LangGraph](https://www.langchain.com/langgraph) library to build an agentic workflow modeled as a graph.

The graph consists of three main parts:

1. **State**: a shared object that flows through the graph. For conversational workflows this is primarily the chat transcript.
2. **Nodes**: functions that read the state and transform it. You can think of these as "steps" in the workflow: calling an LLM, making tool calls, and so on.
3. **Edges**: the transitions between nodes, drawing the "graph" of valid transitions from node to node.

Taken together this models the complete agentic loop (LLM call -> tool call -> LLM call -> until done).

Once this `RuntimeSession` and its underlying graph is complete, callers invoke it:

```typescript
const response = await session.invoke();
```

This runs through the workflow graph until it completes, at which point you handle the response.

This entire flow follows a normal request-reponse cycle, rebuilding the graph and invoking it with each user "turn": typically, in a conversational workflow, each turn is user input from the chat. This means we need to need to persist the output of each `invoke` so we can revive this context on subsequent turns. We call these _persisted threads_, and at a high level they work by:

1. On each turn, `materializeSession` checks if there is already a persisted thread for the current session context.
2. If there is a persisted thread, it "hydrates" the chat history. There is a limit to how long this history can be; messages that go beyond the limit fall out of the context.
3. After the graph runs, `invoke` persists the last chat turn to the thread.

