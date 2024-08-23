
resource "aws_identitystore_user" "example-user" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-sso-instance.identity_store_ids)[0]
  display_name      = "testuser"

  name {
    given_name  = "Test"
    family_name = "User"
  }

  user_name = "testuser"
}

# Create an IAM User and add to the IAM Group
resource "aws_iam_user" "example-user" {
  name = "example-user"
}

resource "aws_iam_user_group_membership" "example-user-group-membership" {
  user   = aws_iam_user.example-user.name
  groups = [aws_iam_group.example-group.name]
}

# apply permission sets to other aws accounts
resource "aws_ssoadmin_account_assignment" "account-assignment" {
  instance_arn       = aws_ssoadmin_permission_set.example-permission-set.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-permission-set.arn
  principal_id       = data.aws_identitystore_group.identity-store-group.group_id
  principal_type     = "GROUP"
  target_id          = sensitive(data.aws_organizations_organization.example-org.id)
  target_type        = "AWS_ACCOUNT"
}
resource "aws_identitystore_user" "example-user" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example-sso-instance.identity_store_ids)[0]
  display_name      = "testuser"

  name {
    given_name  = "Test"
    family_name = "User"
  }

  user_name = "testuser"
}

# Create an IAM User and add to the IAM Group
resource "aws_iam_user" "example-user" {
  name = "example-user"
}

resource "aws_iam_user_group_membership" "example-user-group-membership" {
  user   = aws_iam_user.example-user.name
  groups = [aws_iam_group.example-group.name]
}

# apply permission sets to other aws accounts
resource "aws_ssoadmin_account_assignment" "account-assignment" {
  instance_arn       = aws_ssoadmin_permission_set.example-permission-set.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.example-permission-set.arn
  principal_id       = data.aws_identitystore_group.identity-store-group.group_id
  principal_type     = "GROUP"
  target_id          = sensitive(data.aws_organizations_organization.example-org.id)
  target_type        = "AWS_ACCOUNT"
}