output "bucket-name" {
  value = aws_s3_bucket.upload-bucket.bucket
}

output "sg-id" {
  value = aws_security_group.lambda-sg.id
}

output "vpc-id" {
  value = aws_vpc.main.id 
}

output "subnet1-id" {
  value = aws_subnet.public-1.id 
}

output "subnet2-id" {
  value = aws_subnet.public-2.id 
}