variable "db-name" {
  type    = string
  default = "main-db"
}

variable "db-host" {
  type    = string
  default = "db-host-name"
}

variable "secret-name" {
  type    = string
  default = "db-secrets"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type = string 
  default = "dev"
}
