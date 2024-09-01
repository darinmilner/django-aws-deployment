resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow TLS inbound and outbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Traffic from ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-tls"
  }
}
