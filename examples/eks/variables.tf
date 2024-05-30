variable "hcp_terraform_org_name" {
  type        = string
  description = "The name of the HCP Terraform organization"
}

# An example map of IAM role ARNs that need access to the EKS cluster
# {
#   "arn:aws:sts::000000000000:assumed-role/aws_user" =
#   {
#     "policy_arn" = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy",
#     "type"       = "namespace",
#     "namespaces" = [ "default", "terraform-cloud-operator"]
#   }
# }
variable "eks_access_entry_map" {
  type = map(object({
    policy_arn = string,
    type       = string
    namespaces = list(string)
  }))
  description = "ARNs of the IAM roles that need access to the EKS cluster"
  default     = {}
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version to use for EKS Cluster"
  default     = "1.30"
}

variable "instance_types" {
  type        = list(string)
  description = "Instance types for the EKS managed node group"
  default     = ["t3.medium", "t3a.medium"]
}

variable "volume_size" {
  type        = number
  description = "Size of the EBS volume for the EKS managed node group"
  default     = 80
}

variable "volume_type" {
  type        = string
  description = "Type of the EBS volume for the EKS managed node group"
  default     = "gp2"
}
