provider "aws" {
  region = var.region # Specify the AWS region
}

locals {
  short_region = replace(var.region, "-", "")
  env          = "dev"
}
