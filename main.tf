provider "aws" {
  region = var.region
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnets" {
  source               = "./modules/subnets"
  vpc_id               = module.vpc.vpc_id
  vpc_cidr             = var.vpc_cidr
  num_public_subnets   = var.num_public_subnets
  num_private_subnets  = var.num_private_subnets
  availability_zones   = var.availability_zones
  public_route_table_id = module.vpc.public_route_table_id
  project_name         = var.project_name
  environment          = var.environment
  tags                 = var.tags
}

module "eks_cluster" {
  source = "./modules/EKS"

  eks_cluster_name          = "${var.project_name}-${var.environment}"
  eks_cluster_role_arn      = module.eks_cluster_role.eks_cluster_iam_role_arn
  endpoint_private_access   = true
  endpoint_public_access    = true
  public_access_cidrs       = ["0.0.0.0/0"]
  subnet_ids                = concat(module.subnets.private_subnets, module.subnets.public_subnets)
  encryption_config         = ""
  enabled_cluster_log_types = []
  service_ipv4_cidr         = var.vpc_cidr
  ip_family                 = "ipv4"
  k8s_version               = 1.27
  department                = var.department
  user                      = var.user
  environment               = var.environment
  project_name              = var.project_name  
}

module "eks_cluster_role" {
  source = "./modules/IAM"

  eks_cluster_iam_role_name     = "EKSClusterRole-TF"
  eks_worker_node_iam_role_name = "EKSWorkerNodeRole-TF"
}

module "node-group-01" {
  source               = "./modules/EKS-NodeGroup"
  cluster_name         = element(split("/",module.eks_cluster.cluster_arn),length(split("/",module.eks_cluster.cluster_arn))-1)
  node_group_name      = var.node_group_name
  vpc_id               = module.vpc.vpc_id
  vpc_cidr             = var.vpc_cidr
  node_role_arn        = module.eks_cluster_role.eks_worker_node_iam_role_arn
  desired_instances    = 1
  max_instances        = 1
  min_instances        = 1
  capacity_type        = "ON_DEMAND"
  ami_type             = "AL2_x86_64"
  force_update_version = true
  instance_types       = ["t3.medium"]
  subnet_ids           = module.subnets.private_subnets
  disk_size            = 30
  labels = {
    "NodeGroup" = "Node-Group-01"
  }
  ec2_ssh_key = "${var.project_name}-${var.environment}-EKS-Keypair"

  department = var.department
  user       = var.user
}

module "aurora-cluster" {
  source = "./modules/aurora"
  allocated_storage = 100
  allow_major_version_upgrade = false
  apply_immediately = false
  availability_zones = var.availability_zones
  backup_retention_period = 1
  cluster_identifier_prefix = "${var.project_name}-${var.environment}-cluster"
  database_name = "test"
  db_cluster_parameter_group_name = ""
  db_instance_parameter_group_name = ""
  subnet_group_name = "${var.project_name}-${var.environment}-aurora-subnet-group"
  subnet_ids = module.subnets.private_subnets
  engine_version = "5.7.mysql_aurora.2.03.2"
  engine = "aurora-mysql"
  master_password = "test"
  master_username = "test"
  network_type = "IPV4"
  port = "3306"
  preferred_backup_window = "04:00-09:00"
  cidr_blocks = ["0.0.0.0/0"]
  vpc_id = module.vpc.vpc_id
  tags = var.tags
}

module aws_s3_bucket {
  source = "./modules/S3"
  bucket = "${var.project_name}-${var.environment}-bucket"
  Environment = "${var.environment}"
  name = "${var.project_name}"
}

module aws_s3_bucket_1 {
  source = "./modules/S3"
  bucket = "${var.project_name}-${var.environment}-bucket-1"
  Environment = "${var.environment}"
  name = "${var.project_name}"
}

module aws_rds {
  source = "./modules/RDS"
  allocated_storage    = 100
  backup_retention_period = 1
  identifier_prefix = "${var.project_name}-${var.environment}-rds-instance"
  network_type = "IPV4"
  db_name              = "test"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "test"
  password             = "test123456"
  parameter_group_name = "default.mysql8.0"
  port = "3306"
  tags = var.tags
  subnet_ids = module.subnets.private_subnets
  cidr_blocks = ["0.0.0.0/0"]
  vpc_id = module.vpc.vpc_id
  subnet_group_name = "${var.project_name}-${var.environment}-rds-instance-subnet-group"
  multi_az= "true"
}

module ecr {
  source = "./modules/ECR"
  ecr_name = var.ecr_name
  image_tag_mutability = "MUTABLE"
  scan_on_push = "true"
}

#count