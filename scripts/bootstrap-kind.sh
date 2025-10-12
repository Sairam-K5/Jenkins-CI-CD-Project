#!/usr/bin/env bash
set -euo pipefail
CLUSTER_NAME=ci-cd-cluster
REG_NAME=kind-registry
REG_PORT=5000

# Create a local registry
if [ "$(docker ps -q -f name=${REG_NAME})" = "" ]; then
  docker run -d --restart=always -p ${REG_PORT}:5000 --name ${REG_NAME} registry:2
fi

# Create a kind cluster connected to registry
cat <<EOF | kind create cluster --name ${CLUSTER_NAME} --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${REG_PORT}"]
    endpoint = ["http://${REG_NAME}:5000"]
nodes:
- role: control-plane
- role: worker
EOF

# Connect registry to kind network
docker network connect "kind" ${REG_NAME} || true

kubectl cluster-info --context kind-${CLUSTER_NAME}

# Install Argo CD
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

