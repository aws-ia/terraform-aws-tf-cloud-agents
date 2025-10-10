<!-- BEGIN_TF_DOCS -->
# Terraform Cloud Agent on Amazon ECS

This solution creates self-hosted HashiCorp Cloud Platform (HCP) Terraform agent on Amazon ECS cluster. HCP Terraform allows you to manage isolated, private, or on-premises infrastructure using self-hosted HCP Terraform agents. The agent polls HCP Terraform or HCP Terraform Enterprise for any changes to your configuration and executes the changes locally, so you do not need to allow public ingress traffic to your resources. Agents allow you to control infrastructure in private environments without modifying your network perimeter.

## Architecture

![Terraform Cloud Agent on Amazon ECS architecture](/assets/architecture.png)

## Prerequisites

To use this module you need to have the following:

1. [HashiCorp Cloud Platform (HCP) Terraform](https://www.hashicorp.com/products/terraform) subscription
2. Terraform API token with permission to create Terraform agent pool
3. AWS account and credentials to provision resources as mentioned below.
4. VPC with private subnets

## Getting Started

Please refer to the [examples](./examples/basic) on how to get started.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.54 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | >= 0.54 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | git::https://github.com/terraform-aws-modules/terraform-aws-ecs | be968fc4af733fae2ac41dfb3c34dce7712e028f |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.hcp_terraform_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.hcp_terraform_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.agent_init_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ssm_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.log_ssm_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.hcp_terraform_agent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.agent_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [tfe_agent_pool.ecs_agent_pool](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_pool) | resource |
| [tfe_agent_token.ecs_agent_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_token) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.agent_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.agent_init_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcp_terraform_org_name"></a> [hcp\_terraform\_org\_name](#input\_hcp\_terraform\_org\_name) | The name of the HCP Terraform or HCP Terraform Enterprise organization where the agent pool will be configured. The combination of `hcp_terraform_org_name` and `name` must be unique within an AWS account. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | A name to apply to resources. The combination of `name` and `hcp_terraform_org_name` must be unique within an AWS account. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | IDs of the subnet(s) where agents can be deployed | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster is running. | `string` | n/a | yes |
| <a name="input_agent_auto_update"></a> [agent\_auto\_update](#input\_agent\_auto\_update) | Whether the agent should auto-update. Valid values are minor, patch, and disabled. | `string` | `"minor"` | no |
| <a name="input_agent_cidr_blocks"></a> [agent\_cidr\_blocks](#input\_agent\_cidr\_blocks) | CIDR blocks to allow the agent to communicate with the HCP Terraform instance. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_agent_cpu"></a> [agent\_cpu](#input\_agent\_cpu) | The CPU units allocated to the agent container(s). See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-tasks-size | `number` | `256` | no |
| <a name="input_agent_egress_ports"></a> [agent\_egress\_ports](#input\_agent\_egress\_ports) | Egress ports to allow the agent to communicate with the HCP Terraform instance. | `set(string)` | <pre>[<br>  "443",<br>  "7146"<br>]</pre> | no |
| <a name="input_agent_image"></a> [agent\_image](#input\_agent\_image) | The Docker image to launch. | `string` | `"hashicorp/tfc-agent:latest"` | no |
| <a name="input_agent_log_level"></a> [agent\_log\_level](#input\_agent\_log\_level) | The logging verbosity for the agent. Valid values are trace, debug, info (default), warn, and error. | `string` | `"info"` | no |
| <a name="input_agent_memory"></a> [agent\_memory](#input\_agent\_memory) | The amount of memory, in MB, allocated to the agent container(s). | `number` | `512` | no |
| <a name="input_agent_single_execution"></a> [agent\_single\_execution](#input\_agent\_single\_execution) | Whether to use single-execution mode. | `bool` | `true` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Whether to assign a public IP address to the ECS tasks. Set to true when using public subnets. | `bool` | `false` | no |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the CloudWatch log group where agent logs will be sent. | `string` | `"/hcp/hcp-terraform-agent"` | no |
| <a name="input_cloudwatch_log_group_retention"></a> [cloudwatch\_log\_group\_retention](#input\_cloudwatch\_log\_group\_retention) | The number of days to retain logs in the CloudWatch log group. | `number` | `365` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | Whether the CloudWatch log group should be created. | `bool` | `true` | no |
| <a name="input_create_ecs_cluster"></a> [create\_ecs\_cluster](#input\_create\_ecs\_cluster) | Whether to create a new ECS cluster for the agent. | `bool` | `true` | no |
| <a name="input_create_tfe_agent_pool"></a> [create\_tfe\_agent\_pool](#input\_create\_tfe\_agent\_pool) | Whether to omit agent pool/token creation | `bool` | `true` | no |
| <a name="input_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#input\_ecs\_cluster\_arn) | ARN of the ECS cluster where the agent will be deployed. | `string` | `"arn:aws:ecs:us-west-2:000000000000:cluster/ecs-basic"` | no |
| <a name="input_extra_env_vars"></a> [extra\_env\_vars](#input\_extra\_env\_vars) | Extra environment variables to pass to the agent container. | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_hcp_terraform_address"></a> [hcp\_terraform\_address](#input\_hcp\_terraform\_address) | The HTTPS address of the HCP Terraform or HCP Terraform Enterprise instance. | `string` | `"https://app.terraform.io"` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN of the KMS key to create. If empty, a new key will be created. | `string` | `""` | no |
| <a name="input_num_agents"></a> [num\_agents](#input\_num\_agents) | The number of agent containers to run. | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources deployed by this solution. | `map(any)` | `null` | no |
| <a name="input_task_policy_arns"></a> [task\_policy\_arns](#input\_task\_policy\_arns) | ARN(s) of IAM policies to attach to the agent task. Determines what actions the agent can take without requiring additional AWS credentials. | `list(string)` | `[]` | no |
| <a name="input_tfe_agent_pool_name"></a> [tfe\_agent\_pool\_name](#input\_tfe\_agent\_pool\_name) | Terraform agent pool name to be used when agent creation is omitted | `string` | `""` | no |
| <a name="input_tfe_agent_token"></a> [tfe\_agent\_token](#input\_tfe\_agent\_token) | Terraform agent token to be used when agent creation is omitted | `string` | `""` | no |
| <a name="input_use_spot_instances"></a> [use\_spot\_instances](#input\_use\_spot\_instances) | Whether to use Fargate Spot instances. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_pool_id"></a> [agent\_pool\_id](#output\_agent\_pool\_id) | ID of the HCP Terraform agent pool. |
| <a name="output_agent_pool_name"></a> [agent\_pool\_name](#output\_agent\_pool\_name) | Name of the HCP Terraform agent pool. |
| <a name="output_ecs_service_arn"></a> [ecs\_service\_arn](#output\_ecs\_service\_arn) | ARN of the ECS service. |
| <a name="output_ecs_task_arn"></a> [ecs\_task\_arn](#output\_ecs\_task\_arn) | ARN of the ECS task definition. |
| <a name="output_ecs_task_revision"></a> [ecs\_task\_revision](#output\_ecs\_task\_revision) | Revision number of the ECS task definition. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | The ARN of the created KMS key |
| <a name="output_log_stream_prefix"></a> [log\_stream\_prefix](#output\_log\_stream\_prefix) | Prefix for the CloudWatch log stream. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the VPC security group attached to the service. |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the VPC security group attached to the service. |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | ARN of the IAM role attached to the task containers. |
| <a name="output_task_role_name"></a> [task\_role\_name](#output\_task\_role\_name) | Name of the IAM role attached to the task containers. |
<!-- END_TF_DOCS -->