output "ec2_role_name" {
  value = aws_iam_role.trident_ops_role.name
}

output "ec2_role_arn" {
  value = aws_iam_role.trident_ops_role.arn
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.trident_ops_role_profile.name
}

output "ec2_instance_profile_arn" {
  value = aws_iam_instance_profile.trident_ops_role_profile.arn
}

