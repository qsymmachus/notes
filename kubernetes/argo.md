Argo Rollouts
=============

[Argo Rollouts](https://argo-rollouts.readthedocs.io/en/stable/) is a custom [Kubernetes controller](https://kubernetes.io/docs/concepts/architecture/controller/) which provide more advance deployment strategies than the native `Deployment` controller provided by Kubernetes.

Using rollouts, you can implement deployment strategies like blue-green deploys and canary deploys. These are accomplished using two levers:

* Traffic shaping, which determines what % of traffic should be routed to new replicasets.
* Analysis, where rollouts can query metrics from a variety of sources to determine whether a new replicaset is healthy and ready to be "promoted" or automatically rolled back.

The full `Rollout` specification is defined here: [https://argo-rollouts.readthedocs.io/en/stable/features/specification/](https://argo-rollouts.readthedocs.io/en/stable/features/specification/)

Why rollouts?
-------------

Rollouts exists to fill gaps in the native deployment controller provided by Kubernetes. Why deployments support a `RollingUpdate` strategy which provides some guardrails when deploying a new replicaset, they have the following limitations:

* You can't control the speed of the rollout.
* You can't shape how traffic is sent to the new version.
* Readiness probes provided a very narrow way to perform health checks.
* You can't query external metrics for health checks.
* Can halt progression of an update if something looks off but can't automatically abort and rollback.

Deployment strategies
---------------------

Rollouts provide two deployment strategies, Blue-Green and Canary.

### Blue-Green

When a [Blue-Green deployment](https://argo-rollouts.readthedocs.io/en/stable/features/bluegreen/) is performed, traffic is shifted from an old replicaset ("revision 1" in our examples) to a new replicaset ("revision 2") following some analysis. The result of that analysis determines whether revision 2 will be fully promoted or should be rolled back. For this to work, two `Service`s are set up to handle traffic routing.

It is important to note that unlike canary deployments, traffic is not gradually shifted from the old revision to the new. Once pre-promotion analysis is complete, 100% of traffic is cut over to the new revision.

Blue-Green deployments follow these steps:

1. To start, the revision 1 replicaset is pointed to by _both_ the `activeService` and `previewService`.
2. The pod template spec is modified (somehow), triggering a deployment.
3. The revision 2 replicaset is created, scaled to `spec.replicas` or `previewReplicaCount` if specified.
4. At this point, `previewService` is now pointing to revision 2, and `activeService` is still pointing at revosopm 1.
5. Pre-promotion analysis begins on revision 2, using the analysis strategy defined in `prePromotionAnalysis`.
6. Once pre-promotion analysis is successful, rollout resumes either manually or automatically if `autoPromotionSeconds` or `autoPromotionEnabled` was set.
7. Revision 2 is scaled to the full `spec.replicas` size if `previewReplicaCount` was specified.
8. The rollout "promotes" the revision 2 replicaset by updating the `activeService` to point to it. At this point, there are no services pointing to revision 1.
9. Post-promotion analysis begins as defined in `postPromotionAnalysis`.
10. When analysis succeeds, the deployment is successful. After waiting `scaleDownDelaySeconds, the original revision 1 replicaset is scaled down.

### Canary

[Canary deployments](https://argo-rollouts.readthedocs.io/en/stable/features/canary/) differ from Blue-Green deployments insofar as they attempt to _gradually_ shift traffic from the old revision to the new revision.

The exact rollout strategy is defined as a series of steps the rollout controller uses to manipulate the replicasets and shape traffic during a deployment. Here's an example spec:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: example-rollout
spec:
  replicas: 10
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.4
        ports:
        - containerPort: 80
  minReadySeconds: 30
  revisionHistoryLimit: 3
  strategy:
    canary: # Indicates that the rollout should use the Canary strategy
      maxSurge: "25%"
      maxUnavailable: 0
      steps:
      - setWeight: 10 # Send 10% of traffc to the new revision,
      - pause:
          duration: 1h # for 1 hour.
      - setWeight: 20 # Send 20% of traffic to the new revision,
      - pause: {} # pause indefinitely.
```

By default, the replica count for the new replicaset will be based on the traffic percentage – for example, at 25% weight and a normal replica count of 4, the new replicaset will have 1 pod. But this behavior can be overriden manually with `setCanaryScale` steps.

During rollout, you can specify an [analysis](https://argo-rollouts.readthedocs.io/en/stable/features/analysis/) that should be executed. If analysis is unsuccessful, it will be aborted.

Here's an example rollout spec with an analysis:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: guestbook
spec:
...
  strategy:
    canary:
      analysis:
        templates:
        - templateName: success-rate
        startingStep: 2 # delay starting analysis run until setWeight: 40%
        args:
        - name: service-name
          value: guestbook-svc.default.svc.cluster.local
      steps:
      - setWeight: 20
      - pause: {duration: 10m}
      - setWeight: 40
      - pause: {duration: 10m}
      - setWeight: 60
      - pause: {duration: 10m}
      - setWeight: 80
      - pause: {duration: 10m}
```

The `templateName: success-rate` refers to a separate spec for an `AnalysisTemplate` CRD like this:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: success-rate
spec:
  args:
  - name: service-name
  metrics:
  - name: success-rate
    interval: 5m
    # NOTE: prometheus queries return results in the form of a vector.
    # So it is common to access the index 0 of the returned array to obtain the value
    successCondition: result[0] >= 0.95
    failureLimit: 3
    provider:
      prometheus:
        address: http://prometheus.example.com:9090
        query: |
          sum(irate(
            istio_requests_total{reporter="source",destination_service=~"{{args.service-name}}",response_code!~"5.*"}[5m]
          )) /
          sum(irate(
            istio_requests_total{reporter="source",destination_service=~"{{args.service-name}}"}[5m]
          ))
```
