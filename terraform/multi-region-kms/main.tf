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

provider "aws" {
  alias  = "useast2"
  region = "us-east-2"
}

locals {
  short_region         = replace(var.region, "-", "")
  short_region_useast2 = "useast2"
}

resource "aws_kms_key" "kms-key" {
  description             = "Topic KMS Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  multi_region            = true
  policy                  = data.aws_iam_policy_document.kms-policy.json
}

resource "aws_kms_alias" "kms-alias" {
  name          = "alias/topic-key"
  target_key_id = aws_kms_key.kms-key.key_id
}

resource "aws_kms_replica_key" "replica-key-useast2" {
  provider                = aws.useast2
  description             = "Multi Region Replica Key"
  deletion_window_in_days = 7
  primary_key_arn         = aws_kms_key.kms-key.arn
  policy                  = data.aws_iam_policy_document.kms-policy.json
}

resource "aws_kms_alias" "kms-replica-alias" {
  name          = "alias/topic-key-replica"
  target_key_id = aws_kms_replica_key.replica-key-useast2.key_id
}

# resource "aws_kms_key_policy" "key-policy" {
#   key_id = aws_kms_key.kms-key.id
#   policy = jsonencode({
#     Id = "kms-key-policy-${local.short_region}"
#     Statement = [
#       {
#         Action = "kms:*"
#         Effect = "Allow"
#         Principal = {
#           AWS = "*"
#         }
#         Resource = "*"
#         Sid      = "Enable IAM User Permissions"
#       },
#     ]
#     Version = "2012-10-17"
#   })
# }


