variable "cluster_version" {
  type        = string
  description = "Kubernetes version to use for EKS Cluster"
  default     = "1.30"
}

variable "namespace" {
  type        = string
  description = "Kubernetes Namespace to deploy HCP Terraform agents"
  default     = "hcp-terraform"
}

variable "hcp_tf_helm_config" {
  description = "Helm configuration for the HCP Terraform agent"
  type        = any
  default     = {}
}

variable "create_eks_cluster" {
  type        = bool
  description = "Whether to create a new EKS cluster for the agent."
  default     = true
}

variable "region" {
  type        = string
  description = "AWS region where the EKS cluster will be deployed."
  default     = "us-west-2"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS cluster will be deployed."
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnets where the EKS cluster will be deployed."
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets where the EKS cluster will be deployed."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "hcp-terraform-agent"
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

variable "cluster_endpoint_url" {
  type        = string
  description = "URL of the EKS cluster endpoint"
  default     = "https://example.aws-eks-cluster.com"
  validation {
    condition     = startswith(var.cluster_endpoint_url, "https://")
    error_message = "The address must start with 'https://'"
  }
}

variable "cluster_certificate_authority_data" {
  type        = string
  description = "The base64 encoded certificate authority data for the EKS cluster"
  default     = "AAAAAA=="
}

variable "num_agents" {
  type        = number
  description = "Number of HCP Terraform agents to deploy"
  default     = 1
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
