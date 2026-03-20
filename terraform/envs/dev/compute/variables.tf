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

variable "ami_id" {
  type    = string
  default = "al2023-ami-2023.*-x86_64"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "device_name" {
  type    = string
  default = "/dev/sdf"
}
variable "root_volume" {
  type = map(object({
    volume_size = number
    volume_type = optional(string)
    encrypted   = bool
  }))
  default = null
}
variable "capacity_reservation_preference" {
  type    = string
  default = "open"
}
variable "cpu_credits" {
  type    = string
  default = "standard"
}
variable "instance_initiated_shutdown_behavior" {
  type    = string
  default = "terminate"
}
variable "metadata_options" {
  type = map(object({
    http_endpoint               = string
    http_tokens                 = string
    http_put_response_hop_limit = number
    instance_metadata_tags      = string
  }))
  default = {}
}

variable "monitoring" {
  type    = bool
  default = true
}
