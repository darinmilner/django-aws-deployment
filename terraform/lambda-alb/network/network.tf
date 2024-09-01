resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "main-vpc-${var.environment}-${var.short-region}"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.main.id

  cidr_block              = var.cidr-block1
  availability_zone       = "${var.region}${var.zone1}"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-2" {
  vpc_id = aws_vpc.main.id

  cidr_block              = var.cidr-block2
  availability_zone       = "${var.region}${var.zone2}"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway-${var.environment}-${var.short-region}"
  }
}

resource "aws_route_table" "route-table-public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "route-table-public-${var.environment}-${var.short-region}"
  }
}

resource "aws_route_table_association" "route-table-association-public1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.route-table-public.id
}

resource "aws_route_table_association" "route-table-association-public2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.route-table-public.id
}
