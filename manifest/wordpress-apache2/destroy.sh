#!/bin/bash

kubectl delete -f namespace.yaml
kubectl delete -f ingress.yaml
kubectl delete -f secretclass.yml  
kubectl delete -f stateful.yml             
kubectl delete -f wordpress-configmap.yaml
kubectl delete -f secret.yml
kubectl delete -f wordpress-service.yaml