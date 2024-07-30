resource "aws_security_group" "main" {
  name        = "RDS-SecurityGroup"
  description = "Allow ALL traffic from VPC"
  vpc_id      = var.vpc_id

  tags =var.tags
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.main.id
}