variable "hcp_terraform_org_name" {
  type        = string
  description = "The name of the HCP Terraform organization"
}

variable "eks_access_entry_arns" {
  type        = set(string)
  description = "The ARNs of the HCP Terraform agents to grant access to the EKS cluster"
}
