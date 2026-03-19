variable "prefix" {
  type = string
}
variable "lb_name" {
  type = string
}
variable "internal" {
  type = string
}
variable "load_balancer_type" {
  type = string
}
variable "security_groups" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "enable_deletion_protection" {
  type    = bool
  default = true
}
variable "target_group" {
  type = map(object({
    name             = string
    target_type      = string
    ip_address_type  = string
    port             = number
    protocol         = string
    vpc_id           = string
    protocol_version = string
  }))
}

variable "health_check" {
  type = map(object({
    protocol            = string
    path                = string
    matcher             = string
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout             = number
    interval            = number
  }))
}