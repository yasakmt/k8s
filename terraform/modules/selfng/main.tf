# IAM Role for EKS Nodes
resource "aws_iam_role" "eks_nodes" {
  name        = "self-managed-node-group-complete-example"
  description = "Self managed node group complete example role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Purpose = "Protector of the kubelet"
  }
}

# Attach the AmazonEC2ContainerRegistryReadOnly policy to the role
resource "aws_iam_role_policy_attachment" "eks_nodes_ecr_read_only" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}



# Launch Template for EKS Nodes
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "${var.node_group_name}-"
  instance_type = var.instance_type
  key_name      = var.key_name
  image_id      = "ami-0df33cb954c3f5200" # Ensure this is the correct AMI

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash
  set -o xtrace
  /etc/eks/bootstrap.sh ${var.cluster_name} \
    --apiserver-endpoint '${var.cluster_endpoint}' \
    --b64-cluster-ca '${var.cluster_ca_certificate}'
EOF
)

/*
  iam_instance_profile {
    arn = aws_iam_instance_profile.eks_nodes.arn
  }
*/
  tag_specifications {
    resource_type = "instance"
    tags = {
      "Name" = "${var.node_group_name}-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  }
}

/*
# Instance Profile for EKS Nodes
resource "aws_iam_instance_profile" "eks_nodes" {
  name = aws_iam_role.eks_nodes.name
  role = aws_iam_role.eks_nodes.name
}
*/
# Auto Scaling Group for EKS Nodes
resource "aws_autoscaling_group" "eks_nodes" {
  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "${var.node_group_name}-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }
}

resource "aws_eks_node_group" "example" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}

