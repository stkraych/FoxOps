
# Create a EC2 with user data and connection ----------------------------------------------------------------

resource "aws_instance" "my_aws_instance" {
  ami = data.aws_ssm_parameter.application-ami.value
  instance_type = "t2.micro"
  key_name  = aws_key_pair.application-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.subnet.id

   provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo docker login -u ${var.DOCKERHUB_USERNAME} -p ${var.DOCKERHUB_PASSWORD}",
      "sudo docker pull ${var.DOCKERHUB_USERNAME}/${var.DOCKERHUB_REPO}:${var.TAG}",
      "sudo docker run -d -p 8000:1234 ${var.DOCKERHUB_USERNAME}/${var.DOCKERHUB_REPO}:${var.TAG}",
    ]
  }
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  tags = {
    Name = "application"
  }
}
# Create a Key-Pair ----------------------------------------------------------------

resource "aws_key_pair" "application-key" {
  key_name   = "applicati-key"
  public_key = file("/home/runner/.ssh/id_rsa.pub")
}

# Output of public IP from EC2 ----------------------------------------------------------------

output "Application-Public-IP" {
  value = aws_instance.my_aws_instance.public_ip
}


