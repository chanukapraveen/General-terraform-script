resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn
  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    subnet_ids              = var.subnet_ids
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types
  # encryption_config         = var.encryption_config
  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
    ip_family         = var.ip_family
  }
  version = var.k8s_version
  tags    = merge(local.tags, { Name = "${var.project_name}-${var.environment}" })
}