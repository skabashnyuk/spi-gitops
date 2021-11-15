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
echo "Configuring Kubernetes authentication"
kubectl exec -ti vault-0 -n spi -- vault auth enable kubernetes
kubectl exec -ti vault-0 -n spi -- sh -c 'vault write auth/kubernetes/config \
                                                    issuer="https://kubernetes.default.svc.cluster.local" \
                                                    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
                                                    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
                                                    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt'

kubectl exec -ti vault-0 -n spi -- sh -c 'echo '"'"'path "spi/*" {
   capabilities = ["create", "read", "update", "delete", "list"]
}
   '"'"'> /tmp/policy.webapp.hcl'

kubectl exec -ti vault-0 -n spi -- sh -c 'vault policy write vault-spi-policy /tmp/policy.webapp.hcl'
kubectl exec -ti vault-0 -n spi -- sh -c 'vault write auth/kubernetes/role/vault-spi-role \
                                                    bound_service_account_names=vault-auth-sa \
                                                    bound_service_account_namespaces=spi \
                                                    policies=vault-spi-policy \
                                                    ttl=24h'

