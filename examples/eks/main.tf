#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

data "aws_availability_zones" "available" {}

locals {
  region   = "us-west-2"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  name     = "hcp-tf-agent-${basename(path.cwd)}"
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
  source                = "../../modules/eks"
  region                = local.region
  vpc_id                = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
  private_subnets       = module.vpc.private_subnets
  eks_access_entry_arns = var.eks_access_entry_arns # TODO: remove this when the module is updated
}

#####################################################################################
# VPC
#####################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}
