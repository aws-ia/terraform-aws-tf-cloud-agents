terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }

    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.24.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = ">= 0.54"
    }
  }
}
