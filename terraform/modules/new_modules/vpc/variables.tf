variable "prefix" {
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
