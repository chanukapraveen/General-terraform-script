variable "region" {
  description = "The AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "num_public_subnets" {
  description = "The number of public subnets to create"
  type        = number
}

variable "num_private_subnets" {
  description = "The number of private subnets to create"
  type        = number
}

variable "availability_zones" {
  description = "The list of availability zones to use"
  type        = list(string)
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "department" {
  description = "The environment name"
  type        = string
}
variable "user" {
  description = "The user name"
  type        = string
}

variable "node_group_name" {
  description = "The node group name"
  type        = string
}

variable "ecr_name" {
  description = "ecr name"
  type        = string
}
