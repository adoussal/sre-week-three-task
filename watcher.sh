#!/bin/bash

# Variables
NAMESPACE="sre"
DEPLOYMENT_NAME="swype-app"
MAX_RESTARTS=3

while true; do
  RESTART_COUNT=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT_NAME -o jsonpath='{.items[*].status.containerStatuses[*].restartCount}' | awk '{sum+=$1} END {print sum}')
  echo "Current restart count: $RESTART_COUNT"

  if [[ "$RESTART_COUNT" -gt "$MAX_RESTARTS" ]]; then
    echo "Maximum restart limit exceeded, scaling down the deployment..."
    kubectl scale deployment $DEPLOYMENT_NAME --replicas=0 -n $NAMESPACE
    break
  fi
  sleep 60
done
