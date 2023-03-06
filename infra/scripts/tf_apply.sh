#!/usr/bin/env bash
set -e
set -o pipefail

export STORAGE_ACCOUNT_TFSTATE_NAME="${STORAGE_ACCOUNT_TFSTATE_NAME}"
export ARM_CLIENT_ID="${ARM_CLIENT_ID}"
export ARM_CLIENT_SECRET="${ARM_CLIENT_SECRET}"
export ARM_SUBSCRIPTION_ID="${ARM_SUBSCRIPTION_ID}"
export ARM_TENANT_ID="${ARM_TENANT_ID}"
export ARM_SKIP_PROVIDER_REGISTRATION='true'

# Get full path to the directory containing this script
FULL_SCRIPT_PATH=$(dirname "${BASH_SOURCE[0]}")

# Change to the terraform directory
cd "${FULL_SCRIPT_PATH}/../terraform"

echo 'terraform init'
terraform init \
    -backend-config="storage_account_name=${STORAGE_ACCOUNT_TFSTATE_NAME}" \
    -backend-config="subscription_id=${ARM_SUBSCRIPTION_ID}" \
    -backend-config="resource_group_name=${RESOURCE_GROUP_NAME}" \
    -backend-config="container_name=${STORAGE_ACCOUNT_TFSTATE_CONTAINER_NAME}"

echo 'Selecting terraform workspace'
terraform workspace select "${ENV}"

echo 'terraform apply'
terraform apply -auto-approve "${ENV}"-tfplan