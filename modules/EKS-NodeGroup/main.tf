resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn

  scaling_config {
    desired_size = var.desired_instances
    max_size     = var.max_instances
    min_size     = var.min_instances
  }
  subnet_ids           = var.subnet_ids
  ami_type             = var.ami_type
  capacity_type        = var.capacity_type
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types
  labels               = var.labels
  remote_access {
    ec2_ssh_key               = var.ec2_ssh_key
    source_security_group_ids = ["${aws_security_group.main.id}"]
  }
  tags = merge(local.tags, { Name = "${var.node_group_name}" })
}