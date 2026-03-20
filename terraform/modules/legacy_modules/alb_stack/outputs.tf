output "alb_dns_names" {
  value = {
    web = aws_lb.trident_web_alb.dns_name
    app = aws_lb.trident_app_alb.dns_name
  }
}

output "alb_target_group_arns" {
  value = {
    web = aws_lb_target_group.trident_web_alb_tg.arn
    app = aws_lb_target_group.trident_app_alb_tg.arn
  }
}