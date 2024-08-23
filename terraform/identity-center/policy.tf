# Create IAM Policy
resource "aws_iam_policy" "example-permission-set-policy" {
  name        = "example-permission-set-policy-${local.short_region}"
  description = "Policy for S3 access"
  policy      = data.aws_iam_policy_document.example-permission-set-policy.json
}

# Create a permission set in AWS SSO
resource "aws_ssoadmin_permission_set" "example-permission-set" {
  instance_arn     = tolist(data.aws_ssoadmin_instances.example-sso-instance.arns)[0] # Gets the first instance arn 
  name             = "example-permission-set-${local.short_region}"
  description      = "Example Permission Set for S3 access"
  session_duration = "PT1H" # Set the session duration to one hour

  tags = {
    Environment = local.env
    Region      = var.region
  }
}

resource "aws_ssoadmin_permission_set_inline_policy" "admin-inline-policy" {
  inline_policy      = data.aws_iam_policy_document.example-permission-set-policy.json
  instance_arn       = aws_ssoadmin_permission_set.example-permission-set.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-permission-set.arn
}

resource "aws_ssoadmin_managed_policy_attachment" "policy-attachment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example-sso-instance.arns)[0] # Gets the first instance arn 
  managed_policy_arn = aws_iam_policy.example-permission-set-policy.arn
  permission_set_arn = aws_ssoadmin_permission_set.example-permission-set.arn
}
