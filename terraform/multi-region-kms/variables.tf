variable "region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "key-name" {
  description = "Name for the KMS Key"
  default     = "s3-key"
}