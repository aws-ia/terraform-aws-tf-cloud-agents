### General

variable "name" {
  type        = string
  description = "A name to apply to resources. The combination of `name` and `hcp_terraform_org_name` must be unique within an AWS account."
}

variable "tags" {
  description = "Map of tags to apply to resources deployed by this solution."
  type        = map(any)
  default     = null
}

### HashiCorp Cloud Platform

variable "hcp_terraform_address" {
  type        = string
  description = "The HTTPS address of the HCP Terraform or HCP Terraform Enterprise instance."
  default     = "https://app.terraform.io"
  validation {
    condition     = startswith(var.hcp_terraform_address, "https://")
    error_message = "The address must start with 'https://'"
  }
}

variable "hcp_terraform_org_name" {
  type        = string
  description = "The name of the HCP Terraform or HCP Terraform Enterprise organization where the agent pool will be configured. The combination of `hcp_terraform_org_name` and `name` must be unique within an AWS account."
}

variable "create_tfe_agent_pool" {
  type        = bool
  default     = true
  description = "Whether to omit agent pool/token creation"
}

variable "tfe_agent_token" {
  type        = string
  default     = ""
  description = "Terraform agent token to be used when agent creation is omitted"
  sensitive   = true
}

variable "tfe_agent_pool_name" {
  type        = string
  default     = ""
  description = "Terraform agent pool name to be used when agent creation is omitted"
}

### Terraform Agent

variable "agent_cpu" {
  type        = number
  description = "The CPU units allocated to the agent container(s). See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html#fargate-tasks-size"
  default     = 256
  validation {
    condition     = var.agent_cpu >= 256
    error_message = "The CPU value must be at least 256."
  }
}

variable "agent_memory" {
  type        = number
  description = "The amount of memory, in MB, allocated to the agent container(s)."
  default     = 512
  validation {
    condition     = var.agent_memory >= 512
    error_message = "The memory value must be at least 512."
  }
}

variable "agent_log_level" {
  type        = string
  description = "The logging verbosity for the agent. Valid values are trace, debug, info (default), warn, and error."
  default     = "info"
  validation {
    condition     = contains(["trace", "debug", "info", "warn", "error"], var.agent_log_level)
    error_message = "Valid values: trace, debug, info, warn, error"
  }
}

variable "agent_image" {
  type        = string
  description = "The Docker image to launch."
  default     = "hashicorp/tfc-agent:latest"
}

variable "agent_single_execution" {
  type        = bool
  description = "Whether to use single-execution mode."
  default     = true
}

variable "agent_auto_update" {
  type        = string
  description = "Whether the agent should auto-update. Valid values are minor, patch, and disabled."
  default     = "minor"
  validation {
    condition     = contains(["minor", "patch", "disabled"], var.agent_auto_update)
    error_message = "Valid values: minor, patch, disabled"
  }
}

variable "agent_egress_ports" {
  type        = set(string)
  description = "Egress ports to allow the agent to communicate with the HCP Terraform instance."
  default     = ["443", "7146"]
}

variable "agent_cidr_blocks" {
  type        = list(string)
  description = "CIDR blocks to allow the agent to communicate with the HCP Terraform instance."
  default     = ["0.0.0.0/0"] #HCP Terraform APIs ["75.2.98.97/32","99.83.150.238/32"]
}

variable "extra_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Extra environment variables to pass to the agent container."
  default     = []
}

variable "num_agents" {
  type        = number
  description = "The number of agent containers to run."
  default     = 1
}

### CloudWatch configuration

variable "create_cloudwatch_log_group" {
  type        = bool
  description = "Whether the CloudWatch log group should be created."
  default     = true
}

variable "cloudwatch_log_group_retention" {
  type        = number
  description = "The number of days to retain logs in the CloudWatch log group."
  default     = 365
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0], var.cloudwatch_log_group_retention)
    error_message = "Valid values for var: cloudwatch_log_group_retention are (1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0)."
  }
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "The name of the CloudWatch log group where agent logs will be sent."
  default     = "/hcp/hcp-terraform-agent"
}

### ECS Cluster configuration

variable "create_ecs_cluster" {
  type        = bool
  description = "Whether to create a new ECS cluster for the agent."
  default     = true
}

variable "ecs_cluster_arn" {
  type        = string
  description = "ARN of the ECS cluster where the agent will be deployed."
  validation {
    condition     = can(regex("^arn:aws[a-z-]*:ecs:", var.ecs_cluster_arn))
    error_message = "Must be a valid ECS cluster ARN."
  }
  default = "arn:aws:ecs:us-west-2:000000000000:cluster/ecs-basic"
}

variable "use_spot_instances" {
  type        = bool
  description = "Whether to use Fargate Spot instances."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the cluster is running."
  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]+$", var.vpc_id))
    error_message = "Must be a valid VPC ID."
  }
}

variable "subnet_ids" {
  type        = list(string)
  description = "IDs of the subnet(s) where agents can be deployed"
  validation {
    condition = alltrue([
      for i in var.subnet_ids : can(regex("^subnet-[a-zA-Z0-9]+$", i))
    ])
    error_message = "Must be a list of valid subnet IDs."
  }
}

variable "task_policy_arns" {
  type        = list(string)
  description = "ARN(s) of IAM policies to attach to the agent task. Determines what actions the agent can take without requiring additional AWS credentials."
  default     = []
}


variable "kms_key_arn" {
  description = "The ARN of the KMS key to create. If empty, a new key will be created."
  type        = string
  default     = ""
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign a public IP address to the ECS tasks. Set to true when using public subnets."
  default     = false
}
