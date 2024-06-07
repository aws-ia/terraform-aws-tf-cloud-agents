variable "hcp_terraform_org_name" {
  type        = string
  description = "The name of the HCP Terraform organization."
}

variable "github_oauth_token_id" {
  type        = string
  description = "GitHub OAuth token for connecting the VCS"
  sensitive   = true
}

variable "vcs_repo_identifier" {
  type        = string
  description = "GitHub repo identifier"
}

variable "tfe_agent_pool" {
  type        = string
  description = "Terraform Cloud Agent pool id"
}