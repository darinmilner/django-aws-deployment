provider "aws" {
  region = var.region
}

provider "archive" {}

locals {
  environment  = "dev"
  short-region = replace(var.region, "-", "")
}
