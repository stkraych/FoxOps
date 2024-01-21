data "aws_ssm_parameter" "application-ami" {
  name = var.ami
}


data "aws_route_table" "main_route_table" {
  filter {
    name   = "association.main"
    values = ["true"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.vpc.id]
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}
