output "role" {
  value = {
    arn  = aws_iam_role.role.arn
    name = aws_iam_role.role.name
  }
}

output "instance_role" {
  value = {
    arn  = aws_iam_instance_profile.instance_profile.arn
    name = aws_iam_instance_profile.instance_profile.name
  }
}