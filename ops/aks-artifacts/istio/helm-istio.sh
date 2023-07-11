#!/bin/bash

#https://istio.io/latest/docs/setup/install/helm/

kubectl create namespace istio-system

helm install istio-base istio/base -n istio-system --set defaultRevision=default

helm install istiod istio/istiod -n istio-system --wait

helm ls -n istio-system

helm status istiod -n istio-system

