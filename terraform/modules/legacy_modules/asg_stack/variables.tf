variable "name_prefix" {
  type = string
}

variable "environment" {
  type = string
}
variable "project" {
  type = string
}
variable "owner" {
  type = string
}
variable "managedby" {
  type = string
}

variable "asg_names" {
  type = map(string)
  default = {
    web = "web-asg"
    app = "app-asg"
  }
}

variable "web_launch_template" {
  type = string
}
variable "app_launch_template" {
  type = string
}
variable "asg_public_subnets" {
  type = list(string)
}
variable "asg_private_subnets" {
  type = list(string)
}
variable "web_alb_tg_arn" {
  type = string
}
variable "app_alb_tg_arn" {
  type = string
}
