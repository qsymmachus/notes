Kubernetes Observability
------------------------

How can operators observe the health of a Kubernetes cluster and the services running within it? 

There are three key observability "windows" to consider:

1. __Metrics__ – resource stats, event logging, time-series key/value metrics.
2. __Application Logging__ – logs generated by services, often domain-specific.
3. __Tracing__ – allows you to trace the entire life cycle of a request through a distributed system.

Metrics
-------

The current (as of March 2021) standard for scraping and publishing metrics in a Kubernetes cluster is [Prometheus](https://prometheus.io/). Why is it popular?

* Prometheus gathers metrics as a time series of key-value pairs.
* The Prometheus server _pulls_ metrics from its sources, sources don't have to actively _push_ metrics.
* Easily scrapes from [kube state metrics](https://github.com/kubernetes/kube-state-metrics), a system service that listens to the kube API and generates metrics that Prometheus can scrape.
* Prometheus metrics can be queried using its own query language, and these queries can drive alerting using `alert-manager`.
* Prometheus can scrape data from any service that exposes an HTTP endpoint that produces metrics in the correct [exposition format](https://prometheus.io/docs/instrumenting/exposition_formats/).
  * Alternatively, there are a wide range of [exporters](https://prometheus.io/docs/instrumenting/exporters/) that integrate with common services (usually running as a sidecar container) to expose metrics to Prometheus.

![Prometheus Architecture](https://raw.githubusercontent.com/qsymmachus/notes/master/images/prometheus.png))

Application Logging
-------------------

By default in Kubernetes, a container's stdout and stderr are written to a file on the node. This file is what's read when you use the `kubectl logs` command. _Logging agents_ can then read from this file to aggregate logs in a central store for querying.

* [Splunk](https://www.splunk.com/en_us/blog/it/an-insider-s-guide-to-splunk-on-containers-and-kubernetes.html) doesn't appear to have particularly good Kubernetes support yet.
* [Datadog](https://docs.datadoghq.com/agent/kubernetes/log/?tab=daemonset#log-collection) can run a DaemonSet to aggregate logs from Kubernetes log files.

Tracing
-------

[OpenTracing](https://opentracing.io/) is a project to enable open source, vendor neutral distributed tracing. It's an API spec, and frameworks and libraries that implement that spec.

Generally tracing requires services to actively _push_ tracing instrumentation. However, many service meshes, like [Traefik](https://doc.traefik.io/traefik/observability/tracing/jaeger/), provide tracing instrumentation out of the box (Traefik uses Jaeger, see below).

* [Jaeger](https://www.jaegertracing.io/docs/1.22/getting-started/) is a popular project that implements the OpenTracing spec.
    * Requires [client-side instrumentation](https://www.jaegertracing.io/docs/1.22/getting-started/) to be set up on each service you want to trace (or use a service mesh that does this for you).
    * The Jaeger [operator](https://github.com/jaegertracing/jaeger-operator) then collects tracing metrics sent by the clients.
* [Zipkin](https://zipkin.io/) is another popular option, a bit older than Jaeger but also implements the OpenTracing spec as well.

