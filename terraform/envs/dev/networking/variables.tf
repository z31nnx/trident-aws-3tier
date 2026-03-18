variable "region" {
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

variable "vpc_name" {
  type = string
}
variable "cidr_block" {
  type = string
}
variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
variable "enable_dns_support" {
  type    = bool
  default = true
}
variable "subnets" {
  type = map(object({
    type = string
    cidr = string
    az   = string
  }))
  default = {}
}
