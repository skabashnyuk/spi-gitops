#!/bin/bash
#
# Copyright (C) 2021 Red Hat, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#         http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e
echo "Setup vault application"

kubectl create namespace spi --dry-run=client -o yaml | kubectl apply -f -

cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: vault
  namespace: argocd
spec:
  destination:
    namespace: spi
    server: 'https://kubernetes.default.svc'
  source:
    path: components/spi/vault
    repoURL: 'https://github.com/skabashnyuk/spi-gitops.git'
    targetRevision: HEAD
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true

    retry:
      limit: 50 # number of failed sync attempt retries; unlimited number of attempts if less than 0
      backoff:
        duration: 15s # the amount to back off. Default unit is seconds, but could also be a duration (e.g. "2m", "1h")
EOF


