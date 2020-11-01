#!/bin/bash

case ${1} in
plan)
  terraform plan -var-file=sensitive.tfvars
  ;;
fmt)
  terraform fmt .
  ;;
apply)
  terraform apply -var-file=sensitive.tfvars
  ;;
esac