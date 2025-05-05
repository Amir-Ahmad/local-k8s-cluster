# local-k8s-cluster

Local kubernetes cluster with [kind](https://github.com/kubernetes-sigs/kind), [ingress-nginx](https://github.com/kubernetes/ingress-nginx), and working wildcard SSL locally. Useful for learning k8s or testing out things.

## Dependencies:
- [kind](https://github.com/kubernetes-sigs/kind) to create the containerised cluster
- [mkcert](https://github.com/FiloSottile/mkcert) to generate self signed certificates
- [Just](https://github.com/casey/just) as a task runner
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

## Get started

This requires a wildcard domain name that points to 127.0.0.1. This is so we don't need to edit our /etc/hosts file.

By default it uses localtest.me, but this can be overridden (see local_domain_name in the Justfile). Some other domains can be found [here](https://gist.github.com/tinogomes/c425aa2a56d289f16a1f4fcb8a65ea65) and [here](https://stackoverflow.com/questions/1562954/public-wildcard-domain-name-to-resolve-to-127-0-0-1).

1. Create cert

```
just create-cert
```

2. Create cluster

```
just create-cluster
```

3. Deploy ingress-nginx controller and a hello application

```
just deploy-ingress
just deploy-hello
```

You should now be able to access this at https://localtest.me/hello


## What else

 - You can pass through kubectl commands using "just k", e.g. `just k get pod`.
 - Use the environment variable "CLUSTER_NAME" to create/manage additional clusters.
 - `just delete-cluster` will delete the cluster
