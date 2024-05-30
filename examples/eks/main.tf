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

# If the EKS cluster does not exist, the module can create it, needs the VPC and subnets
# Else if the EKS cluster exists, the module needs cluster name, endpoint and CA
module "agent_pool" {
  source                             = "../../modules/eks"
  region                             = local.region
  create_eks_cluster                 = false
  cluster_name                       = module.eks.cluster_name
  cluster_endpoint                   = module.eks.cluster_endpoint
  cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
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
