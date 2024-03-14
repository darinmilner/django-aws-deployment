resource "aws_cognito_user_pool" "user-pool" {
  name = "test-userpool-${var.environment}"

  schema {
    name = "email"
    attribute_data_type = "String"
    required = true 

    // SAML IDP requires attributes to be mutable
    mutable = true 
  }
}

resource "aws_cognito_user_pool_client" "user-pool-client" {
  name = "user-pool-client"
  user_pool_id = aws_cognito_user_pool.user-pool.id 
  supported_identity_providers = [aws_cognito_identity_provider.saml-provider.procider_name]

    # TODO Check callback URLS
  callback_urls = toset(concat(
    [
        "https://${var.dns-name}",
        "https://${var.dns-name}/oauth2/idpresponse",
        "https://${var.dns-name}/saml2/idpresponse"
    ]
    # use sort and for to loop through domaians
    # sort(flatten())
  ))

  # TODO: check docs for complete options
  allowed_oauth_flows_user_pool_client = true 
  allowed_oauth_flows = ["code" ]
  allowed_oauth_scopes = ["openid" ]
  generate_secret = true 
}

resource "aws_cognito_identity_provider" "saml-provider" {
  user_pool_id = local.user-pool-id 
  provider_name = "saml-provider-${var.environment}"
  provider_type = "SAML"

 provider_details = {
   MetadataFile = file("pathto/samlmetadatafile")
   SSORedirectBindingURI = var.sso-redirect-binding-uri 
 }

 # map of user pool attributes
 attribute_mapping = {
   email = "email"
 }
}

resource "aws_cognito_user_pool_domain" "saml-domain" {
  domain = var.dns-name
  user_pool_id = local.user-pool-id 
  certificate_arn = var.cert-arn    # optiona;  cert arn from route 53
}