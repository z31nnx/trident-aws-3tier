variable "name_prefix" {
  type = string
}
variable "db_subnet_group_name" {
  type = string
}
variable "trident_db_sg_id" {
  type = string
}
variable "db_name" {
  type = string
}
variable "db_private_subnets" {
  type = list(string)
}
variable "db_username" {
  sensitive = true
  type      = string
}
variable "db_password" {
  type      = string
  sensitive = true
}