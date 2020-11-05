#!/bin/bash

function get_value_from_tfvars_file() {
  key=${1}
  file_name=${2}
  grep "${key}" "${file_name}" | grep -e '"\(.*\)"' -o | sed 's/"//g'
}

function init() {
  rm -rf .terraform
  subscription_id=$(get_value_from_tfvars_file 'subscription_id' './sensitive.tfvars')
  client_id=$(get_value_from_tfvars_file 'client_id' './sensitive.tfvars')
  tenant_id=$(get_value_from_tfvars_file 'tenant_id' './sensitive.tfvars')
  client_secret=$(get_value_from_tfvars_file 'client_secret' './sensitive.tfvars')
  terraform init \
      -backend-config="client_id=${client_id}" \
      -backend-config="client_secret=${client_secret}" \
      -backend-config="subscription_id=${subscription_id}" \
      -backend-config="tenant_id=${tenant_id}"
}

case ${1} in
init)
  init
  ;;
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