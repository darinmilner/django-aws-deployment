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
  type    = string
  default = "dev"
}

variable "cidr-block" {
  type    = string
  default = "10.0.0.0/24"
}

variable "private-cidrs" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "server-port" {
  type    = string
  default = "8000"
}

variable "all-ports" {
  type    = string
  default = "0"
}

variable "ssh-port" {
  type    = string
  default = "22"
}

variable "http-port" {
  type    = string
  default = "80"
}

variable "https-port" {
  type    = string
  default = "443"
}

variable "all-protocols" {
  type    = string
  default = "-1"
}

variable "tcp-protocol" {
  type    = string
  default = "tcp"
}

variable "open-cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "zone1" {
  type    = string
  default = "a"
}

variable "zone2" {
  type    = string
  default = "b"
}
