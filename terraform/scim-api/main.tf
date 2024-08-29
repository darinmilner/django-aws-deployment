provider "aws" {
  region = var.region
}

locals {
  short-region = replace(var.region, "-", "")
  environment  = "test"
}

module "network" {
  source       = "./network"
  region       = var.region
  short-region = local.short-region
  environment  = local.environment
}

module "lambda" {
  source       = "./lambda"
  region       = var.region
  short-region = local.short-region
  environment  = local.environment
  subnet1      = module.network.subnet1-id
  subnet2      = module.network.subnet2-id
  sg-id        = module.network.security-group-id
}

module "alb" {
  source       = "./alb"
  region       = var.region
  short-region = local.short-region
  environment  = local.environment
  subnet1      = module.network.subnet1-id
  subnet2      = module.network.subnet2-id
  lambda-arn   = module.lambda.lambda-arn
  lambda-name  = module.lambda.lambda-name
  vpc-id       = module.network.vpc-id
}
