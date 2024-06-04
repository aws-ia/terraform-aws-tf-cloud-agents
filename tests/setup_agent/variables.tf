variable "hcp_terraform_org_name" {
  type        = string
  description = "The name of the HCP Terraform organization."
}

variable "tfe_token" {
  type        = string
  description = "Terraform token to be used to create the agent pool."

}