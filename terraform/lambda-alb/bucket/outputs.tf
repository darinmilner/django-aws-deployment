output "cf_domain" {
  value = aws_cloudfront_distribution.static-distribution.domain_name
}

output "bucket-name" {
  value = aws_s3_bucket.upload-bucket.bucket
}