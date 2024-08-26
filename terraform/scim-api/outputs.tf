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

# output "cf_domain" {
#   value = aws_cloudfront_distribution.static-distribution.domain_name
# }

output "exec_lambda_role" {
  value = aws_iam_role.lambda-role.arn
}

output "security_group_id" {
  value = aws_security_group.lambda-sg.id
}
