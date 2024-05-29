<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.47.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agent_pool"></a> [agent\_pool](#module\_agent\_pool) | ../../modules/eks | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcp_terraform_org_name"></a> [hcp\_terraform\_org\_name](#input\_hcp\_terraform\_org\_name) | The name of the HCP Terraform organization | `string` | n/a | yes |
| <a name="input_eks_access_entry_map"></a> [eks\_access\_entry\_map](#input\_eks\_access\_entry\_map) | ARNs of the IAM roles that need access to the EKS cluster | <pre>map(object({<br>    policy_arn = string,<br>    type       = string<br>    namespaces = list(string)<br>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->