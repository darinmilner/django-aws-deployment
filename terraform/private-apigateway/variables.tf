variable "environment" {
  type    = string
  default = "dev"
}

variable "cidr-block1" {
  type    = string
  default = "10.0.0.0/24"
}

variable "cidr-block2" {
  type    = string
  default = "10.0.0.1/24"
}

variable "private-cidrs" {
  type    = list(string)
  default = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "zone1" {
  type    = string
  default = "a"
}

variable "zone2" {
  type    = string
  default = "b"
}