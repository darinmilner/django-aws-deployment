variable "environment" {
  type = string 
  description = "Environment to deploy Cognito"
}

variable "sso-redirect-binding-uri" {
  type = string 
  description = "HTTP-Redirect SSO binding from the SAML metadata file.  Must be in sync with the saml metadata file content"
}

variable "dns-name" {
  type = string 
  description = "DNS name for the authenticate page"
}

variable "cert-arn" {
  type = string
  description = "Route53 cert arn for the user pool domain"
}