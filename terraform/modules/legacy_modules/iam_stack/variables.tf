variable "name_prefix" {
  type = string
}

variable "iam_role_name" {
  type = string
}
variable "iam_instance_profile_name" {
  type = string
}
variable "iam_managed_policies" {
  type = map(string)
  default = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    CloudWatchAgentServerPolicy  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  }
}
