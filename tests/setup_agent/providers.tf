terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
  }
}


provider "aws" {
  region = local.region
  default_tags {
    tags = {
      managed_by = "abp-tf-cloud-agents-test"
    }
  }
}

provider "tfe" {
  token = var.tfe_token
}