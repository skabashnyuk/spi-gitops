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
echo "Installing vault operator"

kubectl create namespace spi --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n spi -f ../components/spi/vault/vault-operator-init.yaml
kubectl apply -n spi -f ../components/spi/vault/vault-crd.yaml
kubectl apply -n spi -f ../components/spi/vault/vault-rbac.yaml
kubectl apply -n spi -f ../components/spi/vault/vault-cr.yaml

#cat <<EOF | kubectl apply -f -
#kind: ClusterRoleBinding
#apiVersion: rbac.authorization.k8s.io/v1
#metadata:
#  name: vault-operator
#  labels:
#    helm.sh/chart: vault-operator-1.14.4
#subjects:
#- kind: ServiceAccount
#  name: vault-operator
#  namespace: spi
#roleRef:
#  kind: ClusterRole
#  name: vault-operator
#  apiGroup: rbac.authorization.k8s.io
#EOF


#cat <<EOF | kubectl apply -f -
#  apiVersion: operators.coreos.com/v1
#  kind: OperatorGroup
#  metadata:
#    name: spi-group
#    namespace: spi
#  spec:
#    targetNamespaces:
#    - spi
#EOF
#
#
#cat <<EOF | kubectl apply -f -
#apiVersion: operators.coreos.com/v1alpha1
#kind: Subscription
#metadata:
#  name: sub-to-my-operator
#  namespace: spi
#spec:
#  channel: beta
#  name: vault
#  source: operatorhubio-catalog
#  sourceNamespace: olm
#  installPlanApproval: Automatic
#EOF