# TODO: Create as own module
data "aws_route53_zone" "my-domain" {
  name         = "mydomain.com"
  private_zone = false
}

# Create CNAME Record and map to the API Gateway
resource "aws_route53_record" "api-domain-record" {
  name = "api"
  type = "CNAME"
  ttl  = "300"

  records = ["${module.api-gateway.rest-api-id}.execute-api.${var.region}.amazonaws.com"]
  zone_id = data.aws_route53_zone.my-domain.zone_id
}
# provision an ACM Certificate to register with the custom domain
resource "aws_acm_certificate" "api-cert" {
  domain_name               = "api.mydomain.com"
  subject_alternative_names = ["api.mydomain.com"]
  validation_method         = "DNS"
}

