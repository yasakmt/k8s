provider "aws" {
  region = var.region
}

# Data source to fetch the latest Amazon EKS cluster AMI for nodes
data "aws_ami" "eks_nodes" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-v*"]
  }

  most_recent = true
  owners      = ["amazon"] # AWS account ID
}


resource "aws_eks_cluster" "example" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.subnet_ids
    
  }

  version = var.cluster_version
}





resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}


##############FARGATE#############
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  iam_role_name          = coalesce(var.iam_role_name, var.name, "fargate-profile")
  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
  cni_policy             = var.cluster_ip_family == "ipv6" ? "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/AmazonEKS_CNI_IPv6_Policy" : "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy"
}

################################################################################
# IAM Role
################################################################################

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create && var.create_iam_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = var.create && var.create_iam_role ? 1 : 0

  name        = var.iam_role_use_name_prefix ? null : local.iam_role_name
  name_prefix = var.iam_role_use_name_prefix ? "${local.iam_role_name}-" : null
  path        = var.iam_role_path
  description = var.iam_role_description

  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy[0].json
  permissions_boundary  = var.iam_role_permissions_boundary
  force_detach_policies = true

  tags = merge(var.tags, var.iam_role_tags)
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in toset(compact([
    "${local.iam_role_policy_prefix}/AmazonEKSFargatePodExecutionRolePolicy",
    var.iam_role_attach_cni_policy ? local.cni_policy : "",
  ])) : k => v if var.create && var.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = { for k, v in var.iam_role_additional_policies : k => v if var.create && var.create_iam_role }

  policy_arn = each.value
  role       = aws_iam_role.this[0].name
}

################################################################################
# Fargate Profile
################################################################################

resource "aws_eks_fargate_profile" "this" {
  count = var.create ? 1 : 0

  cluster_name           = var.cluster_name
  fargate_profile_name   = var.name
  pod_execution_role_arn = var.create_iam_role ? aws_iam_role.this[0].arn : var.iam_role_arn
  subnet_ids             = var.private_subnets_ids

  dynamic "selector" {
    for_each = var.selectors

    content {
      namespace = selector.value.namespace
      labels    = lookup(selector.value, "labels", {})
    }
  }

  dynamic "timeouts" {
    for_each = [var.timeouts]
    content {
      create = lookup(var.timeouts, "create", null)
      delete = lookup(var.timeouts, "delete", null)
    }
  }

  tags = var.tags
}


