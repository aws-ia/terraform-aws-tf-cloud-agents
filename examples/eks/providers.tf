terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
  }
}

provider "aws" {
  region = local.region
}