### Cluster Role

resource "aws_iam_role" "eks_cluster_iam_role" {
  name = var.eks_cluster_iam_role_name
  assume_role_policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [data.aws_iam_policy.eks_cluster_policy.arn]
}

### Node Role

resource "aws_iam_role" "eks_worker_node_iam_role" {
  name = var.eks_worker_node_iam_role_name
  assume_role_policy = jsonencode({

    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [data.aws_iam_policy.ecr_readonly_policy.arn, data.aws_iam_policy.eks_cni_policy.arn, data.aws_iam_policy.eks_worker_node_policy.arn]
}