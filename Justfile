local_domain_name := env_var_or_default('LOCAL_DOMAIN_NAME', 'localtest.me')
cluster_name := env_var_or_default('CLUSTER_NAME', 'dev')
kindconfig := justfile_directory() / "kindconfig.yaml"
kubeconfig := "$HOME/.kube/kindconfig"
kubectl := "kubectl --kubeconfig=" + kubeconfig + " --context kind-" + cluster_name

# Print help
@help:
    just --list

# Create cert
@create-cert:
    mkdir -p certs
    mkcert -install
    mkcert -cert-file certs/server.crt \
    -key-file certs/server.key \
    '*.{{local_domain_name}}' '{{local_domain_name}}' localhost 127.0.0.1

# Create cluster
@create-cluster:
    # create cluster if it doesnt exist
    if ! kind get clusters | grep -q "^{{cluster_name}}$"; then \
        kind create cluster --kubeconfig "{{kubeconfig}}" --config "{{kindconfig}}" --name "{{cluster_name}}"; \
    fi

# Delete cluster
@delete-cluster:
    kind delete cluster --name "{{cluster_name}}"

# Recreate cluster
@recreate-cluster: delete-cluster create-cluster

# Deploy ingress controller with tls certificate
@deploy-ingress:
    # Create tls secret
    {{kubectl}} create secret tls localcert --key certs/server.key --cert certs/server.crt \
          --dry-run=client -o yaml | {{kubectl}} apply -f -

    # Deploy ingress-nginx controller
    {{kubectl}} apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

    echo "Waiting for ingress-nginx to be ready"
    {{kubectl}} wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s

# Deploy a nginx hello app
@deploy-hello:
    {{kubectl}} create deployment hello --image=nginxdemos/hello \
        --dry-run=client -o yaml | {{kubectl}} apply -f -
    {{kubectl}} create service clusterip hello --tcp=8080:80 \
        --dry-run=client -o yaml | {{kubectl}} apply -f -
    {{kubectl}} create ingress hello --class=nginx \
        --rule="{{local_domain_name}}/hello=hello:8080,tls=localcert" \
        --dry-run=client -o yaml | {{kubectl}} apply -f -
    
    echo "Hello application is accessible at https://{{local_domain_name}}/hello"

# Pass through kubectl commands, e.g. just k get pod
@k *command:
    {{kubectl}} {{command}}
