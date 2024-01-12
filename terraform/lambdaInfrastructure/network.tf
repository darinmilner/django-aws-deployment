resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.environment}MainVPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id

  cidr_block              = var.cidr-block
  availability_zone       = var.zone1
  map_public_ip_on_launch = true
}

resource "aws_vpc_endpoint" "s3-endpoint" {
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.private-route.id]
  vpc_id          = aws_vpc.main.id
}

resource "aws_vpc_endpoint" "dynamodb-endpoint" {
  service_name       = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids    = [aws_route_table.private-route.id]
  security_group_ids = []
  vpc_id             = aws_vpc.main.id
}

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "Main Internet Gateway"
#   }
# }

# resource "aws_route_table" "public-route" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = var.open-cidr
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "Public Route Table"
#   }
# }

# resource "aws_route_table_association" "public-rt-assoc" {
#   route_table_id = aws_route_table.public-route.id
#   subnet_id      = aws_subnet.public.id
# }

# resource "aws_route_table" "private-route" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = var.open-cidr
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "Private Route Table"
#   }
# }

# resource "aws_route_table_association" "private-rt-assoc" {
#   route_table_id = aws_route_table.private-route.id
#   subnet_id      = aws_subnet.private.id
# }

resource "aws_security_group" "lambda-sg" {
  name        = "lambda-sg"
  description = "lambda security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Open API port 8080"
    from_port   = var.server-port
    to_port     = var.server-port
    protocol    = var.all-protocols
    cidr_blocks = [var.open-cidr]
  }

  egress {
    description = "Outbound traffic"
    from_port   = var.all-ports
    to_port     = var.all-ports
    protocol    = var.all-protocols
    cidr_blocks = [var.open-cidr]
  }

  tags = {
    Name = "Lambda-sg"
  }
}

resource "aws_security_group" "server-sg" {
  name        = "server-sg"
  description = "server security group"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Open API port 8080"
    from_port   = var.server-port
    to_port     = var.server-port
    protocol    = var.all-protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = var.ssh-port
    to_port     = var.ssh-port
    protocol    = var.tcp-protocol
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    description = "Outbound traffic"
    from_port   = var.all-ports
    to_port     = var.all-ports
    protocol    = var.all-protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Server-sg"
  }
}