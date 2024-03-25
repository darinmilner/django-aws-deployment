terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
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

module "Cognito" {
  source = "./congnito"
  environment = var.environment
  sso-redirect-binding-uri = "your-uri"
  cert-arn = "your-cert0arn"
  dns-name = "your-dns"
}