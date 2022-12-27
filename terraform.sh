#!/bin/bash
echo "Terraform Init"
terraform init

echo "Terraform get to update the resource"
terraform get

echo "Terraform fmt to check the formate of Infra"
terraform fmt

echo "Terraform validate is check the validation"
terraform validate

echo "Terraform tflint is use to check the validation in Infra"
tflint
