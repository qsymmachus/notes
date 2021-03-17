Helm
====

[Helm](https://helm.sh/docs) is billed as a "package manager for Kubernetes". It allows you to manage Kubernetes applications packaged as __charts__. You can find and share charts using Helm so you can easily reproduce and extend builds of your Kubernetes applications.

* Helm has two parts: a client (`helm`) and a server (`tiller`).
* Tiller runs inside of the Kubernetes cluster, and manages the installation of your charts.
* Helm runs on your machine, CI/CD pipeline, or wherever else you manage deployments.

__Note__: The client/server model using Tiller is specific to Helm v2, Helm v3 has a very different model that deprecates Tiller. Instead of sending requests to a client (Tiller), Helm v3 acts as a domain proxy and forwards requests directly to the Kubernetes API. This means you don't need Tiller running in your target cluster, and also means that Helm inherits whatever Kubernetes permissions (RBAC) you have on your local machine. You can read more about the differences between Helm v2 and v3 [here](https://helm.sh/docs/topics/v2_v3_migration/).

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

There's more than one way to install a chart! All these methods work:

* From a repository (shown above)
* A chart directory (also shown above)
* A local chart archive (`helm install my-dope-chart-0.0.1.tgz`)
* A full URL (`helm install https://example.com/charts/my-dope-chart-0.0.1.tgz`)

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

Finally, you can see what values a release is using with this command:

```
helm get values mysql
```

### Upgrades and rollbacks

An upgrade takes an existing release and upgrades it according to your specifications. Helm is clever and will only try to upgrade things that have changed since the last release, rather than do a full reinstallation.

Most often you just want to supply a new config file to an existing release. Here's what that looks like:

```
helm upgrade -f my-new-config.yaml mysql stable/mysql
```

Helm keeps a history of upgrades it has performed. This means if you blow something up, you can rollback to a previous version of the release:

```
helm rollback mysql 1
```

This command reverts the release to its very first version, `1`. You can use `helm history <release>` to see a full list of revision numbers.

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

### Delete a release

To uninstall a release, use the `helm delete` command:

```
helm delete <release name>
```

### Making your own charts

It's a good idea to read the [chart documentation](https://github.com/helm/helm/blob/master/docs/charts.md) before you roll your own chart. That said, the Helm CLI provides some tooling to make this easier.

The `create` command will create a skeleton chart directory you can start with:

```
helm create my-dope-chart
```

You can validate a chart with `helm lint`.

When your chart is ready, you can package it into a tarball:

```
helm package my-dope-chart
```
