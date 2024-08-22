# Define a policy document for the permission set
data "aws_iam_policy_document" "example-permission-set-policy" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
    ]
    resources = [
      "arn:aws:s3:${var.account-id}::${var.bucket-name}",
      "arn:aws:s3:${var.account-id}::${var.bucket-name}",
    ]
    effect = "Allow"
  }
}

# Example: Reference to the SSO Instance
data "aws_ssoadmin_instances" "example-sso-instance" {}

#Identity Store Group - Fetches the SSO Groups 
# use for_each to loop over a list of existing groups
data "aws_identitystore_group" "identity-store-group" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-sso-instance.identity_store_ids)[0] # Get the first id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = var.group-name  # each.value.group_name if using for_each
    }
  }
}

# Example AWS organization
data "aws_organizations_organization" "example-org" {}

