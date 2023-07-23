resource "aws_vpc" "main" {
  cidr_block           = var.ecs_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "FLASKAPP_ECS_VPC"
  }
}

resource "aws_subnet" "ecs_subnet_a" {
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.main.id
}

resource "aws_subnet" "ecs_subnet_b" {
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.2.0/24"
  vpc_id            = aws_vpc.main.id
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main_vpc_igw"
  }
}

resource "aws_route_table" "flaskapp-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "flaskapp-rt"
  }
}

resource "aws_route_table_association" "flaskapp-rta-sub-a" {
  #count          = length(var.public_cidr)
  subnet_id      = aws_subnet.ecs_subnet_a.id
  route_table_id = aws_route_table.flaskapp-rt.id
}

resource "aws_route_table_association" "flaskapp-rta-sub-b" {
  #count          = length(var.public_cidr)
  subnet_id      = aws_subnet.ecs_subnet_b.id
  route_table_id = aws_route_table.flaskapp-rt.id
}