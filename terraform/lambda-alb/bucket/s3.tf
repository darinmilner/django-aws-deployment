resource "aws_s3_bucket" "upload-bucket" {
  bucket = "scim-api-bucket-${var.short-region}"
}

resource "aws_s3_bucket_acl" "upload-bucket-acl" {
  bucket = aws_s3_bucket.upload-bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_public_access_block" "name" {
   bucket = aws_s3_bucket.upload-bucket.id 

   block_public_policy = false 
}
resource "aws_s3_bucket_server_side_encryption_configuration" "upload-bucket-encryption" {
  bucket = aws_s3_bucket.upload-bucket.id

  rule {
    apply_server_side_encryption_by_default {
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

resource "aws_s3_bucket_ownership_controls" "object-controls" {
  bucket = aws_s3_bucket.upload-bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

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
