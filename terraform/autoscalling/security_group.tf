# Create a Security Group -----------------------------------------------------
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

   ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

# Create a Security Group -----------------------------------------------------
resource "aws_security_group" "allow_sec1" {
  name        = "allow_sec1"
  description = "Allow HTTP inbound traffic to load"
  vpc_id      = aws_vpc.terraform_vpc.id
  
    ingress {
    description      = "Traffic from http_sec_group"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    security_groups = [aws_security_group.allow_http.id] 
  }

     ingress {
    description      = "Traffic from http_sec_group"
    from_port        = 8000
    to_port          = 8000
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }
      # allow https
  ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]

  }
# allow SSH
  ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_trf"
  }

}
