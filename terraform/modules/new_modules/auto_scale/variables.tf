variable "prefix" {
  type = string
}
variable "asg_name" {
  type = string
}
variable "max_size" {
  type    = number
  default = 5
}
variable "min_size" {
  type    = number
  default = 2
}
variable "desired_capacity" {
  type    = number
  default = 2
}
variable "health_check_grace_period" {
  type    = number
  default = 300
}
variable "health_check_type" {
  type    = string
  default = "EC2"
}
variable "force_delete" {
  type    = bool
  default = true
}
variable "vpc_zone_identifier" {
  type        = list(string)
  description = "The AZ of EC2 instances to be deployed"
}
variable "target_group_arns" {
  type = list(string)
}
variable "launch_template" {
  type = string
}
variable "capacity_distribution_strategy" {
  type = string
}
variable "min_healthy_percentage" {
  type = number
}
variable "max_healthy_percentage" {
  type = number
}