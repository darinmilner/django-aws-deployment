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
  api_id         = aws_api_gateway_rest_api.test-api.id
  resource_id    = aws_api_gateway_resource.root-endpoint.id
  http_post_type = "POST"
  ok_response    = "200"
}