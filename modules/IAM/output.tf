output "eks_cluster_iam_role_arn" {
  value = aws_iam_role.eks_cluster_iam_role.arn
}

output "eks_worker_node_iam_role_arn" {
  value = aws_iam_role.eks_worker_node_iam_role.arn
}