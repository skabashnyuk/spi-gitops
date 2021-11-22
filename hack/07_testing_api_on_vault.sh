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
echo "Testing SPI on minikube"
kubectl rollout status deployment/service-provider-integration-api -n spi
SPI_URL=$(minikube service  service-provider-integration-api  --url -n spi)
echo $SPI_URL
#curl -v $SPI_URL/api/v1/token/vvtoken
curl -v -d '{"token":"value1", "name":"vvtoken"}' -H "Content-Type: application/json" -X POST $SPI_URL/api/v1/token
curl -v  $SPI_URL/api/v1/token/vvtoken1
curl -v  $SPI_URL/api/v1/token/vvtoken
