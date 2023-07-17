#!/bin/bash

kubectl apply -f namespace.yaml
kubectl apply -f ingress.yaml
kubectl apply -f secretclass.yml  
kubectl apply -f stateful.yml             
kubectl apply -f wordpress-configmap.yaml
kubectl apply -f secret.yml
kubectl apply -f wordpress-service.yaml