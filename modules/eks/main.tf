data "aws_eks_cluster_auth" "this" {
  name = var.create_eks_cluster ? module.eks[0].cluster_name : var.cluster_name
}

data "aws_availability_zones" "available" {}

#####################################################################################
# HCP Terraform operator - Deploy the operator helm chart to the EKS cluster
#####################################################################################

resource "helm_release" "vault" {
  name             = try(var.hcp_tf_helm_config.name, "terraform-cloud-operator")
  namespace        = try(var.hcp_tf_helm_config.namespace, "terraform-cloud-operator")
  create_namespace = try(var.hcp_tf_helm_config.create_namespace, true)
  description      = try(var.hcp_tf_helm_config.description, null)
  chart            = "terraform-cloud-operator"
  version          = try(var.hcp_tf_helm_config.version, "2.4.0")
  repository       = try(var.hcp_tf_helm_config.repository, "https://helm.releases.hashicorp.com")
  values = try(var.hcp_tf_helm_config.values, [templatefile("${path.module}/config.tftpl", {
    operator_replica_count = 1
    agent_pool_workers     = var.num_agents
  })])

  timeout           = try(var.hcp_tf_helm_config.timeout, 1200)
  devel             = try(var.hcp_tf_helm_config.devel, null)
  wait              = try(var.hcp_tf_helm_config.wait, null)
  wait_for_jobs     = try(var.hcp_tf_helm_config.wait_for_jobs, null)
  dependency_update = try(var.hcp_tf_helm_config.dependency_update, null)
}

#####################################################################################
# EKS Cluster - Optional creation of an EKS cluster to run the HCP Terraform agent
#####################################################################################

module "eks" {
  count   = var.create_eks_cluster ? 1 : 0
  source  = "terraform-aws-modules/eks/aws"
  version = "20.12.0"

  cluster_name                   = var.cluster_name
  cluster_version                = var.cluster_version
  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type                   = "AL2_x86_64"
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {

    default_node_group = {
      name            = "managed_node_group"
      use_name_prefix = true

      subnet_ids = var.private_subnets

      min_size     = 2
      max_size     = 2
      desired_size = 2

      instance_types = var.instance_types

      update_config = {
        max_unavailable_percentage = 1
      }

      description = "EKS managed node group launch template"

      ebs_optimized           = true
      disable_api_termination = false
      enable_monitoring       = true

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {

            volume_size           = var.volume_size
            volume_type           = var.volume_type
            delete_on_termination = true
          }
        }
      }

      create_iam_role          = true
      iam_role_name            = "eks-nodes"
      iam_role_use_name_prefix = false
      iam_role_description     = "EKS managed node group role"
      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonSSMManagedInstanceCore       = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    ingress_cluster_all = {
      description                   = "Cluster to node all ports/protocols"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}
