Sword Sharpening
================

Here's a list of things I like to review periodically to keep my understanding of key concepts fresh. I try to review everything on this list once a year or so. Gotta keep those swords sharp!

Networking
----------

* Relevant chapters in  "The Unix and Linux Administration Handbook":
  * Chapter 14 on TCP/IP Networking
  * Chapter 21 on Network Debugging
* CIDR notation ([cidr.md](https://github.com/qsymmachus/notes/blob/master/cidr.md))

![TCP/IP Layering Model](https://raw.githubusercontent.com/qsymmachus/notes/master/images/TCP-IP-layering-model.jpeg)

Getting Things Done
-------------------

* Stellman & Greene, "Learning Agile"
* [Work is Work](https://codahale.com/work-is-work/) by Coda Hale
  * Contention cost can grow faster than work capacity: "If contention on those [shared] resources is unmanaged, organizational growth can result in catastrophic increases in wait time. At some point, adding new members can cause the organization’s overall productivity to decrease instead of increase, as the increase in wait time due to contention is greater than the increase in work capacity."
  * Invest in reducing resource contention: "If the organization’s intent is to increase value delivery by hiring more people, work efforts must be as independent as possible. Leaders should develop practices and processes to ensure that the work efforts which their strategies consider parallel are _actually parallel_."

Infrastructure
--------------

* Kubernetes and Helm ([kubernetes.md](https://github.com/qsymmachus/notes/blob/master/kubernetes.md))
* Burns et al., "Kubernetes Up and Running"

Distributed Systems
-------------------

* Design patterns outlined in [distributed-systems](https://github.com/qsymmachus/notes/blob/master/distributed-systems)
* Best explanation of the [CAP theorem](https://codahale.com/you-cant-sacrifice-partition-tolerance/)
  * Of the CAP theorem's consistency, availability, and partition tolerance, partition tolerance is mandatory in distributed systems. You can only choose between consistency and availability.
  * A more helpful heuristic may be the tradeoff between _yield_ (percent of requests answered successfully) and _harvest_ (percent of most upt-to-date data included in the responses).
  * The yield/harvest tradeoff is outlined in Fox & Brewer, "Harvest, yield, and scalable tolerant systems" (1999).
* The overview of Consul's architecture is a great real-world illustration of how distributed systems are built in practice: [Consul Architecture](https://www.consul.io/docs/architecture)
  * How Consul uses the [gossip protocol](https://www.consul.io/docs/architecture/gossip) so peers can find each other and detect node failure.
  * How Consul uses [consensus](https://www.consul.io/docs/architecture/consensus) to replicate data across peer nodes and elect a leader.

### Replication and Broadcast

![Replication and Broadcast](https://raw.githubusercontent.com/qsymmachus/notes/master/images/replication-and-broadcast.png)

* Broadcast ordering (a good [summary](https://www.youtube.com/watch?v=A8oamrHf_cQ&list=PLeKd45zvjcDFUEv_ohr_HdUFe97RItdiB&index=12)):
  * __total order__: messages are delivered on all nodes in the same order. Often accomplished with a leader/follower pattern, where a single leader determines total order (see _consensus_ below).
  * __causal__: messages are delivered on all nodes in causal order, but concurrent messages are delivered in any order and may vary from node to node.
  * __reliable__: non-faulty nodes deliver every message, retrying dropped messages.
  * __best-effort__: messages may be dropped.

### Consensus Protocols

* Consensus protocols allow follower nodes to elect a leader, and allows the leader to help followers reach a consensus on shared state. Consensus is _formally equivalent_ to total order broadcast.
* Excellent explanation of the [Raft consensus protocol](https://www.youtube.com/watch?v=IPnesACYRck&list=PLeKd45zvjcDFUEv_ohr_HdUFe97RItdiB&index=19)

![Consensus and Total Order](https://raw.githubusercontent.com/qsymmachus/notes/master/images/consensus-and-total-order.png)

### Distributed Transactions

* Transactions can either be committed or aborted (rolled back). _Distributed_ transactions do this across multiple nodes.

![Distributed Transactions](https://raw.githubusercontent.com/qsymmachus/notes/master/images/distributed-transactions.png)

* Atomic commits sounds similar to _consensus_, but it makes stricter guarantees.

![Atomic Commit vs. Consensus](https://raw.githubusercontent.com/qsymmachus/notes/master/images/atomic-commit-vs-consensus.png)

* _Two-phase commits_ are a common protocol for atomic commits in a distributed system.

![2PC](https://raw.githubusercontent.com/qsymmachus/notes/master/images/two-phase-commit.png)

### Consistency

* How do you define "consistency" when you have multiple nodes reading/writing replicated data?
  * __Linearizability__: This is the strongest definition of consistency. All operations behave as if they were a against a single copy of the data. If a write starts and finish before a read, the read should always return the latest value. Concurrent read/writes make no guarantees about which value is returned by the read, but that's still consistent with linearizability.

Algorithms & Data Structures
----------------------------

* Steven Skiena has a good [introduction to algorithms](https://www.youtube.com/watch?v=A2bFN3MyNDA&list=PLOtl7M3yp-DX32N0fVIyvn7ipWKNGmwpp) lecture series, along with lecture notes.
  * Your notes are saved in [algorithms.pdf](https://github.com/qsymmachus/notes/blob/master/algorithms.pdf).

