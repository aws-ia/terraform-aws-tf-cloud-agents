<!-- BEGIN_TF_DOCS -->
### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch_log_group_name | The name of the CloudWatch log group where agent logs will be sent. | `string` | n/a | yes |
| ecs_cluster_arn | ARN of the ECS cluster where the agent will be deployed. | `string` | n/a | yes |
| hcp_terraform_org_name | The name of the TFC/TFE organization where the agent pool will be configured. The combination of `hcp_terraform_org_name` and `name` must be unique within an AWS account. | `string` | n/a | yes |
| name | A name to apply to resources. The combination of `name` and `hcp_terraform_org_name` must be unique within an AWS account. | `string` | n/a | yes |
| subnet_ids | IDs of the subnet(s) where agents can be deployed (public subnets required) | `list(string)` | n/a | yes |
| vpc_id | ID of the VPC where the cluster is running. | `string` | n/a | yes |
| agent_auto_update | Whether the agent should auto-update. Valid values are minor, patch, and disabled. | `string` | `"minor"` | no |
| agent_cpu | The CPU units allocated to the agent container(s). See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-tasks-size | `number` | `256` | no |
| agent_image | The Docker image to launch. | `string` | `"hashicorp/tfc-agent:latest"` | no |
| agent_log_level | The logging verbosity for the agent. Valid values are trace, debug, info (default), warn, and error. | `string` | `"info"` | no |
| agent_memory | The amount of memory, in MB, allocated to the agent container(s). | `number` | `512` | no |
| agent_single_execution | Whether to use single-execution mode. | `bool` | `true` | no |
| extra_env_vars | Extra environment variables to pass to the agent container. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| hcp_terraform_address | The HTTPS address of the HCP Terraform or HCP Terraform enterprise instance. | `string` | `"https://app.terraform.io"` | no |
| num_agents | The number of agent containers to run. | `number` | `1` | no |
| task_policy_arns | ARN(s) of IAM policies to attach to the agent task. Determines what actions the agent can take without requiring additional AWS credentials. | `list(string)` | `[]` | no |
| use_spot_instances | Whether to use Fargate Spot instances. | `bool` | `false` | no |

### Outputs

| Name | Description |
|------|-------------|
| agent_pool_id | ID of the HCP Terraform agent pool. |
| agent_pool_name | Name of the HCP Terraform agent pool. |
| ecs_service_arn | ARN of the ECS service. |
| ecs_task_arn | ARN of the ECS task definition. |
| ecs_task_revision | Revision number of the ECS task definition. |
| log_stream_prefix | Prefix for the CloudWatch log stream. |
| security_group_id | ID of the VPC security group attached to the service. |
| security_group_name | Name of the VPC security group attached to the service. |
| task_role_arn | ARN of the IAM role attached to the task containers. |
| task_role_name | Name of the IAM role attached to the task containers. |
<!-- END_TF_DOCS -->