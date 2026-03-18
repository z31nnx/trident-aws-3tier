variable "prefix" {
  type = string
}
variable "role_name" {
  type = string
}
variable "trusted_arns" {
  type = list(string)
}
variable "policy_arns" {
  type = list(string)
}
variable "max_session_duration" {
  type    = number
  default = 3600
}