resource "aws_db_instance" "default" {
  allocated_storage    = var.allocated_storage
  multi_az = var.multi_az
  backup_retention_period = var.backup_retention_period
  db_subnet_group_name = var.subnet_group_name
  identifier_prefix = var.identifier_prefix
  network_type = var.network_type
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  db_name              = var.db_name
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  port = var.port
  depends_on = [ aws_db_subnet_group.default ]
}
