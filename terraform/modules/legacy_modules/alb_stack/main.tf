# Web ALB 
resource "aws_lb" "trident_web_alb" {
  name               = var.alb_names["web"]
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.trident_web_alb_sg_id]
  subnets            = var.alb_public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.name_prefix}-${var.alb_names["web"]}"
  }
}

resource "aws_lb_target_group" "trident_web_alb_tg" {
  name             = "${var.alb_names["web"]}-tg"
  port             = 80
  protocol         = "HTTP"
  ip_address_type  = "ipv4"
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"
  target_type      = "instance"

  health_check {
    protocol            = "HTTP"
    path                = "/index.html"
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "${var.name_prefix}-${var.alb_names["web"]}-tg"
  }
}

resource "aws_lb_listener" "trident_web_alb_listener" {
  load_balancer_arn = aws_lb.trident_web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.trident_web_alb_tg.arn
  }
}

# App ALB 
resource "aws_lb" "trident_app_alb" {
  name               = var.alb_names["app"]
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.trident_app_alb_sg_id]
  subnets            = var.alb_private_subnets

  enable_deletion_protection = false

  tags = {
    Name = "${var.name_prefix}-${var.alb_names["app"]}"
  }
}

resource "aws_lb_target_group" "trident_app_alb_tg" {
  name             = "${var.alb_names["app"]}-tg"
  port             = 80
  protocol         = "HTTP"
  ip_address_type  = "ipv4"
  vpc_id           = var.vpc_id
  protocol_version = "HTTP1"
  target_type      = "instance"

  health_check {
    protocol            = "HTTP"
    path                = "/app/index.html"
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "${var.name_prefix}-${var.alb_names["app"]}-tg"
  }
}

resource "aws_lb_listener" "trident_app_alb_listener" {
  load_balancer_arn = aws_lb.trident_app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.trident_app_alb_tg.arn
  }
}
