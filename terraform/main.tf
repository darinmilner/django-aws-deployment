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

provider "random" {
  
}

# Secret Manager 
resource "random_password" "dbpassword" {
  length  = 30
  special = false
}

#Create an AWS Secret for the db
resource "aws_secretsmanager_secret" "dbsecretmaster" {
  name = var.secret-name
  kms_key_id = aws_kms_key.secret-kms-key.id 

  tags = {
    "Name" = "AppSecrets"
  }
}

resource "random_string" "djangokey" {
  length  = 35
  special = true
}

resource "random_string" "djangoadmin" {
  length  = 32
  special = true
}

resource "aws_secretsmanager_secret_version" "dbsecret" {
  secret_id     = aws_secretsmanager_secret.dbsecretmaster.id
  secret_string = <<EOF
    {
      "POSTGRES_USERNAME": "admin1",
      "POSTGRES_PASSWORD": "${random_password.dbpassword.result}",
      "DJANGO_SECRET_KEY": "${random_string.djangokey.result}",
      "POSTGRES_DB" : "${var.db-name}",
      "DJANGO_SUPERUSER_PASSWORD" : "${random_string.djangoadmin.result}",
      "POSTGRES_HOST": "${var.db-host}"
    }
EOF
}

resource "aws_secretsmanager_secret_policy" "secret-policy" {
  secret_arn = aws_secretsmanager_secret.dbsecretmaster.arn
  policy     = <<POLICY
  {
		"Version": "2012-10-17",
		"Statement": [
		{
			"Sid": "EnableAllPermissions",
			"Effect": "Allow",
			"Principal": {
				"AWS": "*"
			},
			"Action": [
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetSecretValue",
                "secretsmanager:ListSecrets"
            ],
				"Resource": "*"
			}
		]
	}
POLICY
  lifecycle {
    ignore_changes = [secret_arn, policy]
  }
}