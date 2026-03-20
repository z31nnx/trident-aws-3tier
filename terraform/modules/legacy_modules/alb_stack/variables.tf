variable "name_prefix" {
  type = string
}

variable "alb_names" {
  type = map(string)
  default = {
    web = "web-alb"
    app = "app-alb"
  }
}

variable "vpc_id" {
  type = string
}
variable "alb_public_subnets" {
  type = list(string)
}
variable "alb_private_subnets" {
  type = list(string)
}
variable "trident_web_alb_sg_id" {
  type = string
}
variable "trident_app_alb_sg_id" {
  type = string
}