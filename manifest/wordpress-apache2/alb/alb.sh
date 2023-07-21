#!/bin/bash

kubectl apply -f aws-load-balancer-controller-service-account.yaml
kubectl apply -f v2_4_4_full.yaml
kubectl apply -f v2_4_4_ingclass.yaml
