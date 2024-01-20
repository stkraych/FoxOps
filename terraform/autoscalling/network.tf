# Create a VPC ----------------------------------------------------------------
resource "aws_vpc" "terraform_vpc" {
  cidr_block ="10.0.0.0/16"
}

# Create 4 Subnets ------------------------------------------------------------
resource "aws_subnet" "terraform_sub1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.cidr_ranges.publicA
  availability_zone = "us-east-1a"
  tags = {
    Name = "publicA_subnet"
  }
}

resource "aws_subnet" "terraform_sub2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.cidr_ranges.publicB
  availability_zone = "us-east-1b"
  tags = {
    Name = "publicB_subnet"
  }
}

resource "aws_subnet" "terraform_sub3" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.cidr_ranges.privateA
  availability_zone = "us-east-1a"
  tags = {
    Name = "privateA_subnet"
  }
}

resource "aws_subnet" "terraform_sub4" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.cidr_ranges.privateB
  availability_zone = "us-east-1b"
  tags = {
    Name ="privateB_subnet"
  }
}

# Create a IGW ----------------------------------------------------------------
resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
}

# Create 2 ElasticIP ---------------------------------------------------------
resource "aws_eip" "terraform_elip" {
  domain = "vpc"
}

resource "aws_eip" "terraform_elip2" {
  domain = "vpc"
}

# Create 2 NAT Gateway --------------------------------------------------------
resource "aws_nat_gateway" "terraform_nat" {
  allocation_id = aws_eip.terraform_elip.id
  subnet_id     = aws_subnet.terraform_sub1.id
   tags = {
    Name = "My_nat_1"
  }
}

resource "aws_nat_gateway" "terraform_nat2" {
  allocation_id = aws_eip.terraform_elip2.id
  subnet_id     = aws_subnet.terraform_sub2.id
   tags = {
    Name = "My_nat_2"
  }
}

# Create 4 Routing Tables -----------------------------------------------------
resource "aws_route_table" "terraform_route_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }
   tags = {
    Name = "My_gateway"
  }
}

resource "aws_route_table" "route_nat" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_nat.id
  }
}

resource "aws_route_table" "route_nat2" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform_nat2.id
  }
}

# Assosiate Routing Tables ----------------------------------------------------
resource "aws_route_table_association" "terraform_associate1" {
  subnet_id      = aws_subnet.terraform_sub1.id
  route_table_id = aws_route_table.terraform_route_gateway.id
}

resource "aws_route_table_association" "terraform_associate2" {
  subnet_id      = aws_subnet.terraform_sub2.id
  route_table_id = aws_route_table.terraform_route_gateway.id
}

resource "aws_route_table_association" "terraform_associate3" {
  subnet_id      = aws_subnet.terraform_sub3.id
  route_table_id = aws_route_table.route_nat.id
}

resource "aws_route_table_association" "terraform_associate4" {
  subnet_id      = aws_subnet.terraform_sub4.id
  route_table_id = aws_route_table.route_nat2.id
}