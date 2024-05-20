terraform {
  required_version = ">= 1.0.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.47.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = ">= 0.24.0"
    }
  }
}

provider "awscc" {
  user_agent = [{
    product_name    = "terraform-awscc-"
    product_version = "0.0.1"
    comment         = "V1/AWS-D69B4015/<github repo id>"
  }]
}

provider "aws" {
  region = local.region
}
