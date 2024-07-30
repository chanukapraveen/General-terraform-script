variable "department" {

}

variable "user" {

}

variable "eks_cluster_name" {

}

variable "eks_cluster_role_arn" {

}

variable "endpoint_private_access" {

}

variable "endpoint_public_access" {

}

variable "public_access_cidrs" {

}

variable "subnet_ids" {

}

variable "enabled_cluster_log_types" {

}

variable "encryption_config" {

}

variable "service_ipv4_cidr" {

}

variable "ip_family" {

}

variable "k8s_version" {

}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment name"
  type        = string
}
