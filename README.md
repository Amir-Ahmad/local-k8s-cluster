# local-k8s-cluster

Local kubernetes cluster with [kind](https://github.com/kubernetes-sigs/kind), [ingress-nginx](https://github.com/kubernetes/ingress-nginx), and working wildcard SSL locally. Useful for learning k8s or testing out things.

## Dependencies:
- [kind](https://github.com/kubernetes-sigs/kind) to create the containerised cluster
- [mkcert](https://github.com/FiloSottile/mkcert) to generate self signed certificates
- [Just](https://github.com/casey/just) as a task runner
- [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)

## Get started

1. Set a LOCAL_DOMAIN_NAME in .env file. This domain should be a wildcard domain that redirects to 127.0.0.1. If you don't have one, you can use one from [here](https://gist.github.com/tinogomes/c425aa2a56d289f16a1f4fcb8a65ea65) or [here](https://stackoverflow.com/questions/1562954/public-wildcard-domain-name-to-resolve-to-127-0-0-1). e.g.

```
echo "LOCAL_DOMAIN_NAME=vcap.me" > .env
```

2. Create cert

```
just create-cert
```

3. Create cluster

```
just create-cluster
```

4. Deploy a hello application

```
just deploy-hello
```

You should now be able to access this at https://vcap.me/hello


## What else

 - You can pass through kubectl commands using "just k", e.g. `just k get pod`.
 - Use the environment variable "CLUSTER_NAME" to create/manage additional clusters.
 - `just delete-cluster` will delete the cluster
