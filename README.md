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
  * A more helpful heuristic may be the tradeoff between _yield_ (percent of requests answered successfully) and _harvest_ (percent of data included in the responses).
  * The yield/harvest tradeoff is outlined in Fox & Brewer, "Harvest, yield, and scalable tolerant systems" (1999).

![Replication and Broadcast](https://raw.githubusercontent.com/qsymmachus/notes/master/images/replication-and-broadcast.png)

* Broadcast ordering (a good [summary](https://www.youtube.com/watch?v=A8oamrHf_cQ&list=PLeKd45zvjcDFUEv_ohr_HdUFe97RItdiB&index=12)):
  * __total order__: messages are delivered on all nodes in the same order. Often accomplished with a leader/follower pattern, where a single leader determines total order.
  * __causal__: messages are delivered on all nodes in causal order, but concurrent messages are delivered in any order and may vary from node to node.
  * __reliable__: non-faulty nodes deliver every message, retrying dropped messages.
  * __best-effort__: messages may be dropped.
