resource "aws_rds_cluster" "default" {
allocated_storage = var.allocated_storage
allow_major_version_upgrade = var.allow_major_version_upgrade
apply_immediately = var.apply_immediately
availability_zones = var.availability_zones
backup_retention_period = var.backup_retention_period
cluster_identifier_prefix = var.cluster_identifier_prefix
database_name = var.database_name
db_cluster_parameter_group_name = var.db_cluster_parameter_group_name
db_instance_parameter_group_name = var.db_instance_parameter_group_name
db_subnet_group_name = var.subnet_group_name
engine_version = var.engine_version
engine = var.engine
master_password = var.master_password
master_username = var.master_username
network_type = var.network_type
port = var.port
preferred_backup_window = var.preferred_backup_window
tags = var.tags
vpc_security_group_ids = ["${aws_security_group.main.id}"]
depends_on = [ aws_db_subnet_group.default ]
}
