resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "main-vpc-${local.environment}-${local.short-region}"
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