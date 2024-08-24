# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#     }
#     random = {
#       source = "hashicorp/random"
#     }
#   }
# }

provider "aws" {
  region = var.region
}

# provider "random" {}

locals {
  short-region = replace(var.region, "-", "")
  environment  = "test"
}
