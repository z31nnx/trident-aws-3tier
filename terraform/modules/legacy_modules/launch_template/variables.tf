variable "name_prefix" {
  type = string
}

variable "launch_template_names" {
  type = object({
    web = string
    app = string
  })
}

# EC2 aunch template variables 
variable "ec2_name" {
  type = string
}
variable "instance_types" {
  type = string
}
variable "ec2_instance_profile_name" {
  type = string
}
variable "trident_web_sg_id" {
  type = string
}
variable "trident_app_sg_id" {
  type = string
}
