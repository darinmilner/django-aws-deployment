resource "aws_security_group" "vpc-sg" {
  name        = "vpc-sg"
  description = "Allow API Access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow Health Checks"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id

  cidr_block              = var.cidr-block1
  availability_zone       = var.zone1
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private-b" {
  vpc_id = aws_vpc.main.id

  cidr_block              = var.cidr-block2
  availability_zone       = var.zone2
  map_public_ip_on_launch = false
}


resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.environment}MainVPC"
  }
}