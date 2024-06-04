<!-- BEGIN_TF_DOCS -->
# Create Terraform Cloud Agent and ECS Cluster

This example show how you can run the module to launch dedicated ECS cluster for Terraform Cloud Agent. You need to specify VPC ID which is created via separate VPC module.

On this example, the ECS Task role will use `arn:aws:iam::aws:policy/AdministratorAccess` as it's managed policy.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agent_pool"></a> [agent\_pool](#module\_agent\_pool) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | git::https://github.com/terraform-aws-modules/terraform-aws-vpc | 25322b6b6be69db6cca7f167d7b0e5327156a595 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcp_terraform_org_name"></a> [hcp\_terraform\_org\_name](#input\_hcp\_terraform\_org\_name) | The name of the HCP Terraform organization. | `string` | n/a | yes |
| <a name="input_tfe_token"></a> [tfe\_token](#input\_tfe\_token) | Terraform token to be used to create the agent pool. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_pool_id"></a> [agent\_pool\_id](#output\_agent\_pool\_id) | ID of the HCP Terraform or HCP Terraform Enterprise agent pool. |
| <a name="output_agent_pool_name"></a> [agent\_pool\_name](#output\_agent\_pool\_name) | Name of the HCP Terraform or HCP Terraform Enterprise agent pool. |
| <a name="output_ecs_service_arn"></a> [ecs\_service\_arn](#output\_ecs\_service\_arn) | ARN of the ECS service. |
| <a name="output_ecs_task_arn"></a> [ecs\_task\_arn](#output\_ecs\_task\_arn) | ARN of the ECS task definition. |
| <a name="output_ecs_task_revision"></a> [ecs\_task\_revision](#output\_ecs\_task\_revision) | Revision number of the ECS task definition. |
| <a name="output_log_stream_prefix"></a> [log\_stream\_prefix](#output\_log\_stream\_prefix) | Prefix for the CloudWatch log stream. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the VPC security group attached to the service. |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | Name of the VPC security group attached to the service. |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | ARN of the IAM role attached to the task containers. |
| <a name="output_task_role_name"></a> [task\_role\_name](#output\_task\_role\_name) | Name of the IAM role attached to the task containers. |
<!-- END_TF_DOCS -->