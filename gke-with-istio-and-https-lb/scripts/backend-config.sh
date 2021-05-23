#!/bin/bash

export HC_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="status-port")].nodePort}')
export HC_INGRESS_PATH=$(kubectl -n istio-system get deployments istio-ingressgateway -o jsonpath='{.spec.template.spec.containers[?(@.name=="istio-proxy")].readinessProbe.httpGet.path}')

echo $HC_INGRESS_PORT
echo $HC_INGRESS_PATH

cat <<EOF | kubectl apply -n istio-system -f -
apiVersion: cloud.google.com/v1beta1
kind: BackendConfig
metadata:
  name: http-hc-config
spec:
  healthCheck:
    checkIntervalSec: 2
    timeoutSec: 1
    healthyThreshold: 1
    unhealthyThreshold: 10
    port: 15020
    type: HTTP
    requestPath: ${HC_INGRESS_PATH}
EOF

echo "Backend Config Applied"


