variable "subnet1" {
  description = "First Subnet for the ALB"
}

variable "subnet2" {
  description = "Second Subnet for the ALB"
}

variable "short-region" {
  description = "AWS Short Region"
}

variable "region" {
  description = "AWS Region"
}

variable "environment" {
  description = "Deployment Environment"
}

variable "lambda-arn" {
  description = "Arn of the lambda"
}

variable "lambda-name" {
  description = "Name of the lambda"
}

variable "lambda-alias" {
  description = "Alias ARN of the lambda"
}

variable "lambda-alias-name" {
  description = "Alias name of the lambda"
}

variable "vpc-id" {
  description = "VPC ID"
}