resource "random_string" "password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "password" {
  name = "${var.identifier}.rds_password"
  type = "String"
  value = "${random_string.password.result}"
}

resource "aws_db_instance" "this" {
  allocated_storage         = "${var.allocated_storage}"
  storage_type              = "${var.storage_type}"
  engine                    = "${var.engine}"
  engine_version            = "${var.engine_version}"
  instance_class            = "${var.instance_class}"
  publicly_accessible       = "${var.publicly_accessible}"
  db_subnet_group_name      = "${var.db_subnet_group_name}"
  identifier                = "${var.identifier}"
  name                      = "${var.name}"
  username                  = "${var.username}"
  password                  = "${aws_ssm_parameter.password.value}"
  vpc_security_group_ids    = ["${var.vpc_security_group_ids}"]
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  final_snapshot_identifier = "${var.identifier}-final"
  backup_retention_period   = "${var.backup_retention_period}"
  backup_window             = "${var.backup_window}"
  maintenance_window        = "${var.maintenance_window}"

  tags {
    "Name" = "${var.identifier}"
    "Provisioner" = "Terraform"
  }
}
