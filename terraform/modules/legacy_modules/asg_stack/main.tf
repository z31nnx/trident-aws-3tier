resource "aws_autoscaling_group" "trident_web_asg" {
  name                      = "${var.name_prefix}-${var.asg_names["web"]}"
  max_size                  = 5
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = false
  vpc_zone_identifier       = var.asg_public_subnets # The AZ of EC2 to be deployed in
  target_group_arns         = [var.web_alb_tg_arn]   # The Web ALB

  launch_template {
    name    = var.web_launch_template
    version = "$Latest"
  }

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120

  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity] # Terraform shouldn't try to control scaling, without this, the next apply will match the desired capacity, we dont want that when the instances are scaling
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-${var.asg_names["web"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = var.owner
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = var.managedby
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "trident_web_asg_target_policy" {
  autoscaling_group_name = aws_autoscaling_group.trident_web_asg.name
  name                   = "${var.name_prefix}-${var.asg_names["web"]}-target-policy"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0 # Adjust this based on your workload but 70% CPU 
  }

  depends_on = [aws_autoscaling_group.trident_web_asg]
}

resource "aws_autoscaling_group" "trident_app_asg" {
  name                      = "${var.name_prefix}-${var.asg_names["app"]}"
  max_size                  = 5
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = false
  vpc_zone_identifier       = var.asg_private_subnets # The AZ of EC2 to be deployed in
  target_group_arns         = [var.app_alb_tg_arn]    # The Web ALB

  launch_template {
    name    = var.app_launch_template
    version = "$Latest"
  }

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120

  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity] # Terraform shouldn't try to control scaling, without this, the next apply will match the desired capacity, we dont want that when the instances are scaling
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-${var.asg_names["app"]}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = var.owner
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = var.managedby
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "trident_app_asg_target_policy" {
  autoscaling_group_name = aws_autoscaling_group.trident_app_asg.name
  name                   = "${var.name_prefix}-${var.asg_names["app"]}-target-policy"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0 # Adjust this based on your workload but 70% CPU 
  }

  depends_on = [aws_autoscaling_group.trident_app_asg]
}
