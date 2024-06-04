#!/bin/bash
## NOTE: this script runs at the start of functional test
## use this to load any configuration before the functional test
## TIPS: avoid modifying the .project_automation/functional_test/entrypoint.sh
## migrate any customization you did on entrypoint.sh to this helper script
echo "Executing Pre-Entrypoint Helpers"

#********** TFC Env Vars *************
echo "Load env vars"
export AWS_DEFAULT_REGION=us-east-1
export TFE_TOKEN=`aws secretsmanager get-secret-value --secret-id abp/hcp/token | jq -r ".SecretString"`

#********** Get tfvars from SSM *************
echo "Get *.tfvars from SSM parameter"
aws ssm get-parameter \
  --name "/abp/hcp/functional/terraform_test.tfvars" \
  --with-decryption \
  --query "Parameter.Value" \
  --output "text" \
  --region "us-east-1" >> ./tests/terraform.auto.tfvars