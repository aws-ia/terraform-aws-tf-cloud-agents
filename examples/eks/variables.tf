variable "hcp_terraform_org_name" {
  type        = string
  description = "The name of the HCP Terraform organization"
}

variable "eks_access_entry_arns" {
  type = map(object({
    policy_arn = string,
    type       = string
    namespaces = list(string)
  }))
  description = "ARNs of the IAM roles that need access to the EKS cluster"
}
