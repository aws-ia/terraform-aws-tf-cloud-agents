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
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 20.12.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcp_terraform_org_name"></a> [hcp\_terraform\_org\_name](#input\_hcp\_terraform\_org\_name) | The name of the HCP Terraform organization | `string` | n/a | yes |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes version to use for EKS Cluster | `string` | `"1.30"` | no |
| <a name="input_eks_access_entry_map"></a> [eks\_access\_entry\_map](#input\_eks\_access\_entry\_map) | ARNs of the IAM roles that need access to the EKS cluster | <pre>map(object({<br>    policy_arn = string,<br>    type       = string<br>    namespaces = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | Instance types for the EKS managed node group | `list(string)` | <pre>[<br>  "t3.medium",<br>  "t3a.medium"<br>]</pre> | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the EBS volume for the EKS managed node group | `number` | `80` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of the EBS volume for the EKS managed node group | `string` | `"gp2"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->