terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "random" {}

locals {
  short_region   = replace(var.region, "-", "")
}

module "api-gateway" {
  source = "./api-gateway"
  aws_region = var.region
  environment = var.environment
}