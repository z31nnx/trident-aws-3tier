data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ami_id]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_template" "lt" {
  name = var.lt_name

  block_device_mappings {
    device_name = var.device_name
    dynamic "ebs" {
      for_each = var.root_volume
      content {
        volume_size = ebs.value.volume_size
        volume_type = ebs.value.volume_type
        encrypted   = ebs.value.encrypted
      }
    }
  }
  capacity_reservation_specification {
    capacity_reservation_preference = var.capacity_reservation_preference
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  disable_api_stop        = var.disable_api_stop
  disable_api_termination = var.disable_api_termination

  ebs_optimized = var.ebs_optimized

  iam_instance_profile {
    name = var.instance_profile
  }

  image_id = data.aws_ami.al2023.image_id

  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  instance_type = var.instance_type

  key_name = var.key_name

  monitoring {
    enabled = var.monitoring
  }

  dynamic "metadata_options" {
    for_each = var.metadata_options
    content {
      http_endpoint               = metadata_options.value.http_endpoint
      http_tokens                 = metadata_options.value.http_tokens
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
      instance_metadata_tags      = metadata_options.value.instance_metadata_tags
    }
  }
}

