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

Agile Philosophy & Practice
---------------------------

* Stellman & Greene, "Learning Agile"

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

