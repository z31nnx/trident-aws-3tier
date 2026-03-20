output "launch_template_ids" {
  value = {
    web = aws_launch_template.trident_web_lt.id
    app = aws_launch_template.trident_app_lt.id
  }
}

output "launch_template_names" {
  value = {
    web = aws_launch_template.trident_web_lt.name
    app = aws_launch_template.trident_app_lt.name
  }
}

output "launch_template_latest_versions" {
  value = {
    web = aws_launch_template.trident_web_lt.latest_version
    app = aws_launch_template.trident_app_lt.latest_version
  }
}