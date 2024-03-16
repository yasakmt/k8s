provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  //version = "~> 3.0"

  name = var.name
  cidr = var.cidr
  azs  = var.azs

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  map_public_ip_on_launch = true
  public_subnet_enable_resource_name_dns_a_record_on_launch = true


  tags = {
    "kubernetes.io/cluster/my-cluster" = "shared"
    


  }

  
}

/*
data "aws_subnet_ids" "private" {
  vpc_id = var.name
  tags = {
    Tier = "private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = var.name
  tags = {
    Tier = "public"
  }
}
*/

/*
variable "region" {}
variable "name" {}
variable "cidr" {}
variable "azs" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
*/
