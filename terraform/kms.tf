resource "aws_kms_key" "secret-kms-key" {
  description             = "Secret KMS Key"
  deletion_window_in_days = 7
  enable_key_rotation = true 
}

resource "aws_kms_alias" "kms-alias" {
  name          = "alias/secrets-key"
  target_key_id = aws_kms_key.secret-kms-key.key_id
}

resource "aws_kms_key" "bucket-kms-key" {
  description             = "Bucket KMS Key"
  deletion_window_in_days = 7
  enable_key_rotation = true 
}

resource "aws_kms_alias" "bucket-kms-alias" {
  name          = "alias/bucket-key"
  target_key_id = aws_kms_key.bucket-kms-key.key_id
}

resource "aws_kms_key_policy" "secret-key-policy" {
  key_id = aws_kms_key.secret-kms-key.id
  policy = jsonencode({
    Id = "secret-key-policy"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_kms_key_policy" "bucket-key-policy" {
  key_id = aws_kms_key.bucket-kms-key.id
  policy = jsonencode({
    Id = "bucket-key-policy"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}
