#!/usr/bin/env bash
set -e

# Set environment variables:
export STORAGE_ACCOUNT_NAME="${STORAGE_ACCOUNT_NAME}"
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
    -backend-config="storage_account_name=${STORAGE_ACCOUNT_NAME}" \
    -backend-config="subscription_id=${ARM_SUBSCRIPTION_ID}" \
    -backend-config="resource_group_name=${RESOURCE_GROUP_NAME}" \
    -backend-config="storage_account_name=${STORAGE_ACCOUNT_NAME}"

echo 'Selecting terraform workspace'
if ! terraform workspace select "${ENV}"; then
    terraform workspace new "${ENV}"
fi

echo 'terraform plan'
terraform plan \
    -var "subscription_id=${ARM_SUBSCRIPTION_ID}" \
    -var "location=${LOCATION}" \
    -var "resource_group_name=${RESOURCE_GROUP_NAME}" \
    -var "storage_account_name=${STORAGE_ACCOUNT_NAME}" \
    -var "project_name=${PROJECT_NAME}" \
    -out "${ENV}-tfplan"
