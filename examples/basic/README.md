<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| hcp_terraform_org_name | The name of the HCP Terraform organization | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| agent_pool_id | ID of the TFC agent pool. |
| agent_pool_name | Name of the TFC agent pool. |
| ecs_service_arn | ARN of the ECS service. |
| ecs_task_arn | ARN of the ECS task definition. |
| ecs_task_revision | Revision number of the ECS task definition. |
| log_stream_prefix | Prefix for the CloudWatch log stream. |
| security_group_id | ID of the VPC security group attached to the service. |
| security_group_name | Name of the VPC security group attached to the service. |
| task_role_arn | ARN of the IAM role attached to the task containers. |
| task_role_name | Name of the IAM role attached to the task containers. |
<!-- END_TF_DOCS -->