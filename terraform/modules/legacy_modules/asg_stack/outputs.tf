output "asg_names" {
  value = {
    web = aws_autoscaling_group.trident_web_asg.name
    app = aws_autoscaling_group.trident_app_asg.name
  }
}