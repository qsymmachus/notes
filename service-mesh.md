Service Mesh
============

A "service mesh" is a strategy to allow distributed services to communicate over the network without each having to know how to connect to another service.

In a service mesh, each service instance is paired with a reverse proxy (often called a "sidecar proxy") that is deployed alongside the service instance. Depending on the tool, the proxy may be a daemon (like Linkerd) or a sidecar container (like Envoy). The sidecar proxy is responsible for communication with other services – traffic egress and ingress.

The service instance is not aware of the network at large and only knows about its local proxy.

The Data Plane
--------------

This is a term coined by [Matt Klein](https://blog.envoyproxy.io/service-mesh-data-plane-vs-control-plane-2774e720f7fc?gi=458ee2f3493). In his definition, the data plane is responsible for translating, forwarding, and observing all traffic that flows to and from the service instance. These tasks are performed by the sidecar proxy. In a little more detail, the data plane handles:

* __Service discovery:__ What are all of the services available?
* __Health checking:__ Are the other services healthy and ready to accept traffic?
* __Routing:__ Given a request for `/foo`, where does it need to be sent?
* __Load balancing:__ Once an destination service has been identified, which instance/cluster should it go to?
* __Auth:__ Is an incoming request correctly authenticated and authorized?
* __Observability:__ Log statistics and distribute tracing data to requests to help operators understand traffic flow.

The Control Plane
-----------------

How does a proxy actually know how to route `/foo` to a particular service? How are load balance settings specified? Who configures systemwide auth settings? All these settings that the data plane needs to do its job are managed by the _control plane_.

Traditionally the "control plane" for proxies were actual humans, manually configuring static configurations and deploying them to all the proxies. More advanced control planes will abstract more of the system from the operator through a unified CLI or UI. Configuration data is stored in some kind of persistence layer, ideally also abstracted away from the operator.

In sum, the control plane is what turns the data plane into a distributed system, by providing individual sidecar proxies with the configuration data they need to understand the rest of the mesh.

Some Examples
-------------

Note that this is is the state of the service mesh landscape as of July, 2019. The following tools that are currently bucketed in the "service mesh" category can be more precisely defined as data and control plane tools:

* __Data planes:__ Linkerd, NGINX, HAProxy, Envoy
* __Control planes:__ Istio, Nelson, SmartStack

For example, Istio is a control plane that happens to use Envoy as its default data plane. There is work in progress to allow Istio to be used with Linkerd as the data plane. The important point is that the control and data planes of a service mesh do not need to be tightly coupled.

