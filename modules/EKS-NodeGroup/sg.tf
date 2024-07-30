resource "aws_security_group" "main" {
  name        = "${var.node_group_name}-SecurityGroup"
  description = "Allow ALL traffic from VPC"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, { Name = "${var.node_group_name}-SecurityGroup" })
}

resource "aws_vpc_security_group_ingress_rule" "main" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1"
}