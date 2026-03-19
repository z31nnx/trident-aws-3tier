resource "aws_lb" "lb" {
  name                       = var.lb_name
  internal                   = var.internal
  load_balancer_type         = var.load_balancer_type
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = "${var.prefix}-${var.lb_name}"
  }
}

resource "aws_lb_target_group" "lb_tg" {
  for_each = var.target_group

  name             = each.value.name
  port             = each.value.port
  protocol         = each.value.protocol
  ip_address_type  = each.value.ip_address_type
  vpc_id           = each.value.vpc_id
  protocol_version = each.value.protocol_version
  target_type      = each.value.target_type

  dynamic "health_check" {
    for_each = var.health_check
    iterator = health

    content {
      protocol            = health.value.protocol
      path                = health.value.path
      matcher             = health.value.matcher
      healthy_threshold   = health.value.healthy_threshold
      unhealthy_threshold = health.value.unhealthy_threshold
      timeout             = health.value.timeout
      interval            = health.value.interval
    }
  }
  tags = {
    Name = "${var.prefix}-${var.lb_name}-tg"
  }
}

resource "aws_lb_listener" "listener" {
  for_each          = aws_lb_target_group.lb_tg
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg[each.key].arn
  }
}