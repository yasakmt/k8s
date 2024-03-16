provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/aws-vpc"

  name             = var.vpc_name
  cidr             = var.vpc_cidr
  azs              = var.azs
  private_subnets  = var.private_subnets
  public_subnets   = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  region            = var.region  # Ensure this is supported by your VPC module
}


module "eks" {
  source = "./modules/eks-cluster"

  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids = var.subnet_ids
  region = var.region
  private_subnets_ids = var.private_subnets_ids
  
  
}

/*
module "self-manged-nodegroup" {
  source  = "./modules/selfng"
  cluster_endpoint = var.cluster_endpoint
  cluster_ca_certificate = var.cluster_ca_certificate
  subnet_ids = var.subnet_ids
  node_group_name = var.node_group_name
  instance_type = var.instance_type
  key_name = var.key_name
  cluster_name = var.cluster_name
  node_role_arn = var.node_role_arn
 
  
}
*/


module "kubernetes" {
  source = "./kubeconfig"
  cluster_name = "my-cluster"
 
  region = "us-east-1"
}
