#!/usr/bin/env bash
set -euo pipefail

MANIFEST_PATH=k8s/deployment.yaml
IMAGE=$1

if command -v yq >/dev/null 2>&1; then
  yq eval -i '.spec.template.spec.containers[0].image = env(IMAGE)' ${MANIFEST_PATH}
else
  sed -i "s|image: .*|image: ${IMAGE}|" ${MANIFEST_PATH}
fi

git add ${MANIFEST_PATH}
git commit -m "chore: set image ${IMAGE}"
git push

