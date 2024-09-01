variable "short-region" {
  description = "AWS Short Region"
}

variable "region" {
  description = "AWS Region"
}

variable "environment" {
  description = "Deployment Environment"
}

variable "subnet1" {
  description = "First Subnet for the ALB"
}

variable "subnet2" {
  description = "Second Subnet for the ALB"
}

variable "sg-id" {
  description = "Security Group ID"
}
