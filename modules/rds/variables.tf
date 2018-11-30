variable "allocated_storage" {default = 5}
variable "storage_type" {default = "gp2"}
variable "engine" {default = "postgres"}
variable "engine_version" {default = "9.6.6"}
variable "instance_class" {default = "db.t2.micro"}
variable "publicly_accessible" {default = false}
variable "copy_tags_to_snapshot" {default = true}
variable "name" {}
variable "identifier" {}
variable "username" {}
variable "skip_final_snapshot" {default = false}
variable "db_subnet_group_name" {}
variable "vpc_security_group_ids" {
  type = "list"
  default = []
}

variable "backup_retention_period" {default = 7}
variable "backup_window" {default = "07:28-07:58"}
variable "maintenance_window" {default = "tue:15:00-tue:16:00"}
variable "apply_immediately" {default = true}
