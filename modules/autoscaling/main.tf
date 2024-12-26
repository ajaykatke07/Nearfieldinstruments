resource "aws_launch_template" "app" {
  name_prefix   = "app-launch-template-"
  image_id      = var.ami_id
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.subnet_ids[0] 
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "AutoScalingInstance"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.app] 
}

resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "scale-up"
  min_size               = 2
  max_size               = 5
  desired_capacity       = 2
  recurrence             = "0 6 * * *"
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "scale-down"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 18 * * *"
  autoscaling_group_name = aws_autoscaling_group.app.name
}
