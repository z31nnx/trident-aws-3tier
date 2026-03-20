variable "prefix" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "db_name" {
  type = string
}
variable "engine" {
  type    = string
  default = "msql"
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}
variable "storage_type" {
  type    = string
  default = "gp3"
}
variable "allocated_storage" {
  type    = number
  default = 20
}
variable "max_allocated_storage" {
  type    = number
  default = 1000
}
variable "vpc_security_group_ids" {
  type = list(string)
}
variable "multi_az" {
  type    = bool
  default = true
}
variable "publicly_accessible" {
  type    = bool
  default = false
}
variable "skip_final_snapshot" {
  type    = bool
  default = true
}
variable "backup_retention_period" {
  type    = number
  default = 7
}
variable "storage_encrypted" {
  type    = bool
  default = true
}
variable "auto_minor_version_upgrade" {
  type    = bool
  default = true
}
variable "db_username" {
  type      = string
  sensitive = true
}
variable "db_password" {
  type      = string
  sensitive = true
}
variable "apply_immediately" {
  type    = bool
  default = true
}
variable "deletion_protection" {
  type    = bool
  default = true # set to false when you're in a sandbox/testing 
}
