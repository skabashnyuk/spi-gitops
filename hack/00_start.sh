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
echo "Preparing new minikube"

minikube stop && minikube delete
minikube start --memory=4000mb

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl rollout status deployment/argocd-dex-server -n argocd
kubectl rollout status deployment/argocd-redis -n argocd
kubectl rollout status deployment/argocd-repo-server -n argocd
kubectl rollout status deployment/argocd-server -n argocd

echo "start complete"
