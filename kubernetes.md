KUBERNETES
==========

Kubernetes is a system for orchestrating the deployment, scaling, and management of containerized
applications. See `docker.txt` for more info on containerized applications generally.

You can think of Kubernetes as an additional layer of abstraction over your production infrastructure.
It provides a consistent interface for managing your deployed applications, and automates many common
tasks, most importantly automated service scaling.

Clusters
--------

Kubernetes orchestrates a cluster of computers that are connected to work as a single unit, called a 
_cluster_.

The cluster allows you to deploy containerized applications without tying them to specific individual 
machines.

A cluster has two parts:

* The Master coordinates the cluster. 
  * It is in charge of scheduling, scaling, and updating applications.
  * Clients can manage the cluster by communicating with the master using the Kubernetes API.

* Nodes are the workers that run applications. 
  * It is a VM or physical computer that serves as a worker machine in the cluster.
  * Each node communicates with the master using the Kubernetes API.
    * `kubelet` is the agent that communicates with the master.

kubectl
-------

`kubectl` is a CLI-based client for interacting with the Kubernetes API.

Get information about the cluster:

```
kubectl cluster-info
```

Get a list of all nodes that can host applications:

```
kubectl get nodes
```

Deployments
-----------

Once you have a running Kubernetes cluster, you can deploy containerized applications within it.
To do this, you need to create a Deployment configuration. 

The deployment config not only tells Kubernetes how to deploy the applications, but also how to 
continously manage them. Kubernetes clusters are "self-healing" – if an instance goes down or is 
deleted, the deployment controller replaces it. A deployment is one of many types of Kubernetes [controllers](https://kubernetes.io/docs/concepts/workloads/controllers/deployment).

To create a new deployment of a particular application:

```
kubectl run <name for your deployment> --image=<docker image> --port=<port>
```

Once you start a deployment, a few things happen:

  1. A suitable node is found where an instance of the application can be run,
  2. The application instance is scheduled to run on that node,
  3. The cluster is configured to reschedule the instance when needed.

To check the state of your deployments:

```
kubectl get deployments
```

By default deployment applications are only visible _within_ the cluster. To view your application
without exposing it publicly, you can create a route between your terminal and the cluster with a proxy:

```
kubectl proxy
```

This exposing a temporary proxy to the cluster. To you hit applications within the cluster with the following
URI:

```
http://localhost:8001/api/v1/proxy/namespaces/default/pods/<POD NAME>
```

"Pod Name" is the name of the running application, you can you find out the name of your applications with:

```
kubectl get pods
```

Pods and Nodes
--------------

As we touched on briefly in the last section, Kubernetes creates a _Pod_ to host your application instance.
A pod is an abstraction that represents

1. A group of one or more containers running an application, or a group of closely related applications,
2. Shared networking configuration, 
3. Configuration on how to run each container, like image version.

A pod in turn runs on a _node_, which we've already covered. A node is an abstraction representing an actual
machine the pod is running on (either a real machine or a virtual one).

To see a list of pods: 

```
kubectl get pods
```

To get even more detail about pods: 

```
kubectl describe pods
```

To see container logs:

```
kubectl logs <pod name>
```

To execute a command on a running container:

```
kubectl exec <pod name> <command>

# e.g. Run a bash shell within container:

kubectl ctl exec -ti <pod name> bash
```

Services
--------

A Kubernetes _Service_ is an abstraction which defines a logical set of pods and a policy by which to access them. 
Services enable a loose coupling between dependent pods. Note that while pods are isolated to a particular node,
services _span across multiple nodes_. They serve as an abstraction over the particular hardware applications are
running on. Services are the abstraction that allow pods to die and be replicated across different nodes without 
affecting the behavior of your overall application.

A service is defined using a config file (usually YAML).

In the "Deployments" section above, we noted that running applications are not exposed outside the cluster by default.
_Services_ are what expose running applications (running within pods) to the outside world. You may choose different
ways that a services are exposed by specifiying a `type`:

* `ClusterIP` (default) – exposes the service on an IP internal to the cluster. It can't be reached outside the cluster.
* `NodePort` – exposes the service on a specified port on each node. Makes service accessible outside the cluster.
* `LoadBalancer` – creates an external load balancer and assigns a fixed IP to it. Makes service accessible outside the cluster.
* `ExternalName` – exposes the service using an name by returning a CNAME record. makes service accessible outside the cluster.

To see a list of running services:

```
kubectl get services
```

To create a new service that is exposed to external traffic:

```
kubectl expose deployments/<service name> --type="NodePort" --port 8080
```

Note that `8080` is the application port you want to expose, the actual _external_ port that is exposed is chose randomly. To get
that information ("NodePort"), you can run:

```
kubectl describe service <service name>
```

To delete an existing service:

```
kubectl delete service -l <label to identify service>
```

Labels
------

Labels can be added to pods or services to make them easier to track and identify. A label is just a key-value pair you may assign
to a pod or service:

```
kubectl label pod <pod name> <key>=<value>
```

The key-value pair is the label. For example:

```
kubectl label pod <pod name> version=v1
```

Filter pods with a particular label:

```
kublectl get pods -l <key>=<value>
```

Scaling your Applications
-------------------------

You can use Kubernetes to either manually or automatically scale your applications. Kubernetes accomplishes this by creating
and scheduling new pods to nodes with available resources.

Kubernetes services have an integrated load-balancer that distributes traffic between all the pods.

To see a list of your deployments and their current size:

```
kubectl get deployments
```

To scale up a deployment to say, 4 instances:

```
kubectl scale deployments/<name> --replicas=4
```

Scaling your Applications
-------------------------

Kubernetes allows you to make rolling updates so pods are each deployed in turn without any overall downtime.
Updates are version and any deployment update can be reverted to the previous version (neat!).

To update the docker image used by a particular application deployment:

```
kubectl set image deployments/<name> <name>=<image name>
```

To get the status of a rollout: 

```
kubectl rollout status deployments/<name>
```

To revert a rollout to its previous state:

```
kubectl rollout undo deployments/<name>
```

Using Helm and Charts
---------------------

[Helm](https://helm.sh/docs) is billed as a "package manager for Kubernetes". It allows you to manage Kubernetes applications packaged as __charts__. You can find and share charts using Helm so you can easily reproduce and extend builds of your Kubernetes applications.

* Helm has two parts: a client (`helm`) and a server (`tiller`).
* Tiller runs inside of the Kubernetes cluster, and manages the installation of your charts.
* Helm runs on your machine, CI/CD pipeline, or wherever else you manage deployments.

### Initialize Tiller

After you [install Helm](https://helm.sh/docs/using_helm/#installing-helm), you can spin up Tiller in your cluster with this command:

```
helm init --history-max 200
```

We set a maximum history here to avoid storing resource objects in Helm's history indefinitely.

Note that when Tiller is installed, it does not have any authentication enabled. In a production environment, you should read up on how to [secure your installation](https://helm.sh/docs/using_helm/#securing-your-helm-installation).

### Install a chart (creating a "release")

To install a chart, you run the `helm install` command. There are several ways to find an install a chart; the easiest way is to use one of the official `stable` charts.

For example, here's how we'd pull and install the stable chart for a MySQL deployment:

```
helm repo update
helm install stable/mysql
```

You can also install a chart that's just sitting on your disk by specifying a chart directory:

```
helm install ./my-chart
```

When you install a chart, a new __release__ is created. A chart can be installed multiple times in the same cluster, and each release can be independently managed and upgraded.

To list the releases running in your cluster:

```
helm list
```

### Customizing an install

Installation will use the default configuration options (as defined in the chart's `values.yml` file) for the chart. Often you'll want to customize these values yourself.

To see what options are available on a chart, use this command:

```
helm inspect values stable/mysql
```

Using that list as a guide, you can then write your own custom configuration file, and use it during installation:

```
helm install -f my-config.yaml stable/mysql
```

Alternatively, you can override each value specifically using the `--set` flag. Values overriden in this way will take precedence over values in your custom config.

```
helm install stable/mysql --set mysqlRootPassword=supersecret123
```

### Other useful commands

To keep track of the state of a release, you can use the `status` command:

```
helm status mysql
```

You can search for particular charts available on your repos using the `search command`:

```
helm search redis
```

Not finding something in your repos? You can add a new one, and manage existing ones, with the `repo` command:

```
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
```

### Uninstall a release

To uninstall a release, use the `helm delete` command:

```
helm delete <release name>
```

More resources
--------------

* [Kubernetes concepts](https://kubernetes.io/docs/concepts/overview)
  * [Kubernetes objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/): important for understanding the different kind of objects represented by the API, and how to express them in `.yaml` formate.
  * [Managing objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management): explains and contraststhe different ways of managing Kubernetes objects (e.g. "imperatively" using commands, vs. "declaratively" using config files).
* [kubectl CLI reference doc](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Helm charts and how they work](https://github.com/helm/helm/blob/master/docs/charts.md)
* [Kubernetes networking](https://jvns.ca/blog/2017/10/10/operating-a-kubernetes-network/)

