Terraform code to deploy a Django app

Resource Structure
*kms.tf
**main.tf**
**outputs.tf**

| Resource        | File             | Description               |
| :---------------|:----------------:|--------------------------:|
| s3 Bucket       |s3.tf             | creates an *s3 Bucket*    |
| KMS Key         |kms.tf            | creates a *KMS* key       |
| Secret Manager  |secrets.tf        | creates a *secret*        |
| Random Password |secrets.tf        | creates a *random password* for the DB   |
| Variables       |variables.tf      | file with variables for parameterization.   |
| Outputs         |outputs.tf        | Resource related **outputs** |
