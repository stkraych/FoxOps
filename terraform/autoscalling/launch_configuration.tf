

resource "aws_launch_template" "first_template" {
  name_prefix            = "terraform"
  image_id               = var.used_image
  instance_type          = "t3.micro"
  update_default_version = true

  iam_instance_profile {
    arn = aws_iam_instance_profile.iam_instance_profile.arn
   }

  count = 0

  
   
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "autoscalling-${count.index + 1}"
    }
  }

  user_data = base64encode(
      <<-EOF
    #!/bin/bash
     sudo yum update -y
     sudo yum install docker -y && yum install -y nginx && yum install stress -y
     service docker start
     usermod -a -G docker ec2-user
     docker login -u ${var.DOCKERHUB_USERNAME} -p ${var.DOCKERHUB_PASSWORD}
     docker pull ${var.DOCKERHUB_USERNAME}/${var.DOCKERHUB_REPO}:${var.TAG}
     docker run -d -p 8000:1234 ${var.DOCKERHUB_USERNAME}/${var.DOCKERHUB_REPO}:${var.TAG}
     systemctl enable nginx --now
     stress --cpu 80
  EOF
    )
}

# Create a ASG ----------------------------------------------------------------
resource "aws_autoscaling_group" "my_autoscaling_group" {
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  vpc_zone_identifier = [aws_subnet.terraform_sub3.id, aws_subnet.terraform_sub4.id]
 target_group_arns = [ aws_lb_target_group.alb-target.arn ]
  launch_template {
    id      = aws_launch_template.first_template.id
    version = "${aws_launch_template.first_template.latest_version}"
  }

    tag {
    key                 = "AWS"
    value               = "Autoscalling"
    propagate_at_launch = true
  }

}

# Create Auto Scale Policy ----------------------------------------------------

resource "aws_autoscaling_policy" "the_policy" {
  name                   = "the-auto-policy"
  cooldown               = 30
  autoscaling_group_name = aws_autoscaling_group.my_autoscaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment = 2
}

resource "aws_cloudwatch_metric_alarm" "my_alarm" {
  alarm_name                = "CPU load check 80 or more"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 60
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "Cpu utilization threshold overload - adding another instance"
  alarm_actions = [aws_autoscaling_policy.the_policy.arn]
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.my_autoscaling_group.name
  }
}


# Attach Policy ---------------------------------------------------------------
resource "aws_autoscaling_attachment" "asg_attachment_lb" {
  autoscaling_group_name = aws_autoscaling_group.my_autoscaling_group.id
  lb_target_group_arn = aws_lb_target_group.alb-target.arn
}
