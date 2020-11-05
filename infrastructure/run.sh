#!/bin/bash

function init() {
  # remove old tfstate file
  rm -f ./.terraform/terraform.tfstate

  # az login
  subscription_id=$(grep 'subscription_id' ./sensitive.tfvars | grep -e '"\(.*\)"' -o | sed 's/"//g')
  client_id=$(grep 'client_id' ./sensitive.tfvars | grep -e '"\(.*\)"' -o | sed 's/"//g')
  tenant_id=$(grep 'tenant_id' ./sensitive.tfvars | grep -e '"\(.*\)"' -o | sed 's/"//g')
  client_secret=$(grep 'client_secret' ./sensitive.tfvars | grep -e '"\(.*\)"' -o | sed 's/"//g')
  az login --service-principal --username "${client_id}" --password "${client_secret}" --tenant "${tenant_id}"
  az account set -s "${subscription_id}"

  # get storage account access key
  storage_account_key=$(az storage account keys list --account-name workshopbackend | grep -m1 'value' | awk -F ':' '{print $2}' | grep -e '"\(.*\)"' -o | sed 's/"//g')
  terraform init -backend-config="access_key=${storage_account_key}"
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