region             = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
num_public_subnets = 3
num_private_subnets = 3
availability_zones = ["us-east-1a", "us-east-1b"]
project_name       = "my-project"
environment        = "dev"
department         = "Devops"
user               = "Chanuka"
node_group_name    = "test"
ecr_name = "ecr-test"
tags = {
  Project = "my-project"
  Environment = "dev"
}