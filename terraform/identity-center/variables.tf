variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "bucket-name" {
  description = "Name of the bucket to be given permissions"
  default     = "your-bucket"
}

variable "account-id" {
  description = "Account Id"
  default     = "123456789"
}

variable "group-name" {
  description = "User group name"
  default     = "example-group"
}