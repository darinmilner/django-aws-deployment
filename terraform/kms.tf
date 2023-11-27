resource "aws_kms_key" "secret-kms-key" {
  description             = "Secret KMS Key"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "kms-alias" {
  name          = "alias/secrets-key"
  target_key_id = aws_kms_key.secret-kms-key.key_id
}

resource "aws_kms_key_policy" "example" {
  key_id = aws_kms_key.secret-kms-key.id
  policy = jsonencode({
    Id = "example"
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
