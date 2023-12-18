output "bucket-name" {
  value = aws_s3_bucket.upload-bucket.bucket
}

output "secret-key-arn" {
  value = aws_kms_key.secret-kms-key.arn
}

output "bucket-key-arn" {
  value = aws_kms_alias.bucket-kms-alias.arn 
}