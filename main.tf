data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "tfe_agent_pool" "ecs_agent_pool" {
  count               = var.create_tfe_agent_pool ? 1 : 0
  name                = "${var.name}-agent-pool"
  organization        = var.hcp_terraform_org_name
  organization_scoped = false # always explicitly specify the workspace or override by customer
}

resource "tfe_agent_token" "ecs_agent_token" {
  count         = var.create_tfe_agent_pool ? 1 : 0
  agent_pool_id = tfe_agent_pool.ecs_agent_pool[0].id
  description   = "${var.name}-agent-token"
}

resource "aws_ssm_parameter" "agent_token" {
  name        = "/hcp-tf-token/${var.hcp_terraform_org_name}/${var.name}"
  description = "HCP Terraform agent token"
  type        = "SecureString"
  value       = var.create_tfe_agent_pool ? tfe_agent_token.ecs_agent_token[0].token : var.tfe_agent_token
  key_id      = local.key_id
  tags        = var.tags
}

resource "aws_kms_key" "log_ssm_key" {
  count                   = var.kms_key_arn == "" ? 1 : 0
  description             = "KMS key to encrypt the Log groups and SSM parameters"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy[0].json
}

data "aws_iam_policy_document" "kms_key_policy" {
  count = var.kms_key_arn == "" ? 1 : 0
  statement {
    sid    = "Allow access to the key"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions = [
      "kms:*",
    ]
    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }
  statement {
    sid    = "Allow CloudWatch logs and SSM access to the key"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com",
        "ssm.amazonaws.com"
      ]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }
}

locals {
  key_id = var.kms_key_arn == "" ? aws_kms_key.log_ssm_key[0].arn : var.kms_key_arn
}


resource "aws_cloudwatch_log_group" "cloudwatch" {
  count             = var.create_cloudwatch_log_group ? 1 : 0
  name              = "/hcp/hcp-terraform-agents/ecs/${var.name}"
  retention_in_days = var.cloudwatch_log_group_retention
  kms_key_id        = local.key_id
  tags              = var.tags
}

resource "aws_ecs_task_definition" "hcp_terraform_agent" {
  family                   = "hcp-tf-agent-${var.hcp_terraform_org_name}-${var.name}"
  cpu                      = var.agent_cpu
  memory                   = var.agent_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode(
    [
      {
        name : "hcp-terraform"
        image : var.agent_image
        essential : true
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-create-group : "true",
            awslogs-group : var.create_cloudwatch_log_group ? aws_cloudwatch_log_group.cloudwatch[0].name : var.cloudwatch_log_group_name
            awslogs-region : data.aws_region.current.name
            awslogs-stream-prefix : "hcp-tf-${var.hcp_terraform_org_name}-${var.name}"
          }
        }
        environment = concat([
          {
            name  = "TFC_AGENT_SINGLE",
            value = tostring(var.agent_single_execution)
          },
          {
            name  = "TFC_AGENT_NAME",
            value = "hcp-tf-agent-${var.name}"
          },
          {
            name  = "TFC_ADDRESS",
            value = var.hcp_terraform_address
          },
          {
            name  = "TFC_AGENT_LOG_LEVEL",
            value = var.agent_log_level
          },
          {
            name  = "TFC_AGENT_AUTO_UPDATE",
            value = var.agent_auto_update
          }
        ], var.extra_env_vars),
        secrets = [
          {
            name      = "TFC_AGENT_TOKEN",
            valueFrom = aws_ssm_parameter.agent_token.arn
          }
        ]
      }
    ]
  )
  tags = var.tags
}

resource "aws_ecs_service" "hcp_terraform_agent" {
  name            = "hcp-tf-agent-${var.name}"
  cluster         = var.create_ecs_cluster ? module.ecs_cluster[0].cluster_arn : var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.hcp_terraform_agent.arn
  desired_count   = var.num_agents
  propagate_tags  = "SERVICE"

  deployment_maximum_percent         = "200"
  deployment_minimum_healthy_percent = "33"
  enable_ecs_managed_tags            = "true"

  capacity_provider_strategy {
    capacity_provider = var.use_spot_instances ? "FARGATE_SPOT" : "FARGATE"
    weight            = "1"
  }

  network_configuration {
    assign_public_ip = var.assign_public_ip
    security_groups  = [aws_security_group.hcp_terraform_agent.id]
    subnets          = var.subnet_ids
  }

  lifecycle {
    postcondition {
      condition     = self.desired_count == var.num_agents
      error_message = "The ECS service desired count is not equal to the number of agents specified in the configuration."
    }
  }

  tags = merge(var.tags,
    {
      Name = "hcp-terraform-agent-${var.hcp_terraform_org_name}-${var.name}"
    }
  )
}

resource "aws_security_group" "hcp_terraform_agent" {
  name_prefix = "hcp-tf-${var.hcp_terraform_org_name}-${var.name}-sg"
  description = "Security group for HCP Terraform: ${var.name} in org ${var.hcp_terraform_org_name}"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

#tfsec:ignore:no-public-egress-sgr
resource "aws_security_group_rule" "allow_egress" {
  protocol          = "tcp"
  type              = "egress"
  for_each          = var.agent_egress_ports
  from_port         = each.value
  to_port           = each.value
  cidr_blocks       = var.agent_cidr_blocks
  security_group_id = aws_security_group.hcp_terraform_agent.id
  description       = "Egress rule for HCP Terraform agent"
}

#####################################################################################
# ECS Cluster - Optional creation of an ECS cluster to run the HCP Terraform agent
#####################################################################################

module "ecs_cluster" {
  count  = var.create_ecs_cluster ? 1 : 0
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs?ref=be968fc4af733fae2ac41dfb3c34dce7712e028f" # v6.6.1

  cluster_name = var.name

  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 50
    }
    FARGATE_SPOT = {
      weight = 50
    }
  }

  tags = merge(var.tags,
    {
      Name = var.name
    }
  )
}

#####################################################################################
# IAM
# Two roles are defined: the task execution role used during initialization,
# and the task role which is assumed by the container(s).
#####################################################################################

data "aws_iam_policy_document" "agent_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.name}-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.agent_assume_role_policy.json

  tags = merge(var.tags,
    {
      Name = "hcp-terraform-${var.hcp_terraform_org_name}-${var.name}-ecsTaskExecutionRole"
    }
  )

}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "ssm_access_policy" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      local.key_id
    ]
  }
}

resource "aws_iam_role_policy" "ssm_access_policy" {
  name   = "ssm-access-policy"
  role   = aws_iam_role.ecs_task_execution_role.name
  policy = data.aws_iam_policy_document.ssm_access_policy.json
}

data "aws_iam_policy_document" "agent_init_policy" {
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameters"]
    resources = [aws_ssm_parameter.agent_token.arn]
  }
}

resource "aws_iam_role_policy" "agent_init_policy" {
  role   = aws_iam_role.ecs_task_execution_role.name
  name   = "AccessSSMforAgentToken"
  policy = data.aws_iam_policy_document.agent_init_policy.json
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.name}-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.agent_assume_role_policy.json

  tags = merge(var.tags,
    {
      Name = "hcp-terraform-${var.hcp_terraform_org_name}-${var.name}-ecsTaskRole"
    }
  )

}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  for_each = toset(var.task_policy_arns)

  role       = aws_iam_role.ecs_task_role.name
  policy_arn = each.key
}
