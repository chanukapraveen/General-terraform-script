variable "vpc_id" {
  description = "The ID of the VPC"
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

variable "public_route_table_id" {
  description = "The ID of the public route table"
  type        = string
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
  description = "Tags to apply to the subnets"
  type        = map(string)
  default     = {}
}
