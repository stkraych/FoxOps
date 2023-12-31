resource "aws_instance" "my_aws_instance" {
  ami = data.aws_ssm_parameter.webserver-ami.value
  instance_type = "t2.micro"
  key_name  = aws_key_pair.webserver-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id

   provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo docker login -u seeshellol -p metropolis",
      "sudo docker pull seeshellol/tamago-app:ea8c4d7f61f676231ad77a1a8adc09f134e2d12a",
      "sudo docker run -d -p 8000:1234 seeshellol/tamago-app:ea8c4d7f61f676231ad77a1a8adc09f134e2d12a",
    ]
  }
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  tags = {
    Name = "webserver"
  }
}

resource "aws_key_pair" "webserver-key" {
  key_name   = "webserver-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "Webserver-Public-IP" {
  value = aws_instance.my_aws_instance.public_ip
}

resource "aws_autoscaling_group" "my_autoscaling_group" {
  name                      = "my-autoscaling-group"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  health_check_type         = "EC2"
  vpc_zone_identifier       = [aws_subnet.subnet.id]

  
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "my-autoscaling-group"
    propagate_at_launch = true
  }
}



resource "aws_launch_template" "my_launch_template" {
  name          = "terraform"
  image_id      = data.aws_ssm_parameter.webserver-ami.value
  instance_type = "t2.micro"
  update_default_version = true
  key_name      = aws_key_pair.webserver-key.key_name
  vpc_security_group_ids = [ aws_security_group.sg.id ]

   iam_instance_profile {
    name = aws_iam_instance_profile.iam_instance_profile.name
  }

  user_data     = base64encode(<<EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo docker login -u seeshellol -p metropolis
    sudo docker pull seeshellol/tamago-app:ea8c4d7f61f676231ad77a1a8adc09f134e2d12a
    sudo docker run -d -p 8000:1234 seeshellol/tamago-app:ea8c4d7f61f676231ad77a1a8adc09f134e2d12a
  EOF
  )
}


resource "aws_lb_target_group" "my_target_group" {
  name        = "my-target-group"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}







