resource "aws_s3_bucket" "upload-bucket" {
  bucket = "scim-api-bucket-${var.short-region}"
}

resource "aws_s3_bucket_acl" "upload-bucket-acl" {
  bucket = aws_s3_bucket.upload-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "upload-bucket-encryption" {
  bucket = aws_s3_bucket.upload-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      #   kms_master_key_id = aws_kms_key.bucket-kms-key.arn
      #   sse_algorithm     = "aws:kms"
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "upload-bucket-versioning" {
  bucket = aws_s3_bucket.upload-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# May Not Be Needed
# resource "aws_s3_bucket_cors_configuration" "upload-bucket-cors" {
#   bucket = aws_s3_bucket.upload-bucket.id

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["PUT", "POST"]
#     allowed_origins = ["https://s3-website-test.hashicorp.com"] # TODO: change to website url
#     expose_headers  = ["ETag"]
#     max_age_seconds = 3000
#   }

#   cors_rule {
#     allowed_methods = ["GET"]
#     allowed_origins = ["*"]
#   }
# }

resource "aws_s3_bucket_policy" "upload-bucket-policy" {
  bucket = aws_s3_bucket.upload-bucket.id
  policy = data.aws_iam_policy_document.bucket-access.json
}


data "aws_iam_policy_document" "bucket-access" {
  statement {
    effect = "Allow"
    sid    = "Upload Bucket Policy"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.upload-bucket.arn,
      "${aws_s3_bucket.upload-bucket.arn}/*",
    ]
  }
}
