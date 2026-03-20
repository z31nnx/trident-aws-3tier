output "target_group" {
  value = {
    for k, v in aws_lb_target_group.lb_tg :
    k => {
      arn = v.arn
      id  = v.id
    }
  }
}