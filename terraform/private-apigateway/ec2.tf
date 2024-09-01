resource "aws_instance" "server" {
  ami           = "ami-132432432"  # TODO: Make Dynamic
  instance_type = "t2.micro"
  key_name      = "mykey"
  subnet_id     = aws_subnet.private.id

  vpc_security_group_ids = [aws_security_group.vpc-sg.id]

  tags = {
    Name = "AppServer"
  }
}
