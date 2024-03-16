variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS cluster endpoint."
  type        = string
}

variable "cluster_ca_certificate" {
  description = "EKS cluster CA certificate."
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EKS worker nodes."
  default     = "t3.medium"
}

variable "key_name" {
  description = "Key name of the SSH key to add to the EC2 instances."
  type        = string
  default = "eks-clusters"
}

variable "subnet_ids" {
  description = "List of subnet IDs to launch the nodes in."
  type        = list(string)
}

variable "node_group_name" {
  description = "Name of the node group."
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances in the node group."
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances in the node group."
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the node group."
  default     = 3
}

variable "node_role_arn" {
  description = ""
  type = string
  default = ""
  
}
