resource "aws_autoscaling_group" "asg" {
  name                      = "${var.prefix}-${var.asg_name}-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  force_delete              = var.force_delete
  vpc_zone_identifier       = var.vpc_zone_identifier
  target_group_arns         = var.target_group_arns

  launch_template {
    id      = var.launch_template
    version = "$Latest"
  }
  availability_zone_distribution {
    capacity_distribution_strategy = var.capacity_distribution_strategy
  }

  instance_maintenance_policy {
    min_healthy_percentage = var.min_healthy_percentage
    max_healthy_percentage = var.max_healthy_percentage
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity] # Terraform shouldn't try to control scaling, without this, the next apply will match the desired capacity, we dont want that when the instances are scaling
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-${var.asg_name}-asg"
    propagate_at_launch = true
  }
}