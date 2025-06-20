# variables.tf

variable "region" {
  description = "The AWS region where all resources will be created."
  type        = string
}

variable "name" {
  description = "A name to be used on all the resources as identifier"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "azs" {
  description = "A list of availability zones in the region to deploy into."
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of private subnet CIDR blocks."
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnet CIDR blocks."
  type        = list(string)
}

variable "single_nat_gateway" {
  type = bool
}

variable "enable_nat_gateway" {
  type = bool
}

