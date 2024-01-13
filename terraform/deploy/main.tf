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
      "sudo docker login -u ${github.DOCKERHUB_USERNAME} -p ${github.DOCKERHUB_PASSWORD}",
      "sudo docker pull ${github.DOCKERHUB_USERNAME}/${github.DOCKERHUB_REPO}:${github.TAG}",
      "sudo docker run -d -p 8000:1234 ${github.DOCKERHUB_USERNAME}/${github.DOCKERHUB_REPO}:${github.TAG}",
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
  public_key = file("/home/runner/.ssh/id_rsa.pub")
}

output "Webserver-Public-IP" {
  value = aws_instance.my_aws_instance.public_ip
}


