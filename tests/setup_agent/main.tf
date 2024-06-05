#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

data "aws_availability_zones" "available" {}

locals {
  region   = "us-west-2"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  name     = "ecs-${basename(path.cwd)}"
  vpc_cidr = "10.0.0.0/16"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#####################################################################################
# MODULE INVOCATION
#####################################################################################

module "agent_pool" {
  source                 = "../../"
  name                   = local.name
  hcp_terraform_org_name = var.hcp_terraform_org_name
  agent_image            = "hashicorp/tfc-agent:latest"
  use_spot_instances     = true
  agent_cpu              = 512
  agent_memory           = 2048
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnets
  task_policy_arns       = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}

#####################################################################################
# VPC
#####################################################################################

module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc?ref=25322b6b6be69db6cca7f167d7b0e5327156a595" # v5.8.1

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
