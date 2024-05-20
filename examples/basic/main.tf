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
  source                    = "../../"
  name                      = local.name
  hcp_terraform_org_name    = var.hcp_terraform_org_name
  agent_image               = "hashicorp/tfc-agent:latest"
  use_spot_instances        = true
  agent_cpu                 = 512
  agent_memory              = 1024
  ecs_cluster_arn           = module.ecs_cluster.cluster_arn
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets
  cloudwatch_log_group_name = aws_cloudwatch_log_group.cloudwatch.name
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

#####################################################################################
# ECS CLUSTER DEFINITION
#####################################################################################

resource "aws_cloudwatch_log_group" "cloudwatch" {
  name              = "/ecs/hcp-terraform-agents/${local.name}"
  retention_in_days = 7
}

module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"

  cluster_name = local.name

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = local.tags
}

