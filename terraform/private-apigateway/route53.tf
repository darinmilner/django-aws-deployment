resource "aws_acm_certificate" "api-cert" {
  domain_name       = "yourdomain.com"
  validation_method = "DNS"
}

data "aws_route53_zone" "zone-id" {
  name         = "domain.com"
  private_zone = false
}

resource "aws_route53_record" "api-record" {
  for_each = {
    for dvo in aws_acm_certificate.api-cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone-id.zone_id
}

resource "aws_acm_certificate_validation" "api-cert-validation" {
  certificate_arn         = aws_acm_certificate.api-cert.arn
  validation_record_fqdns = [for record in aws_aws_route53_record.api-record : record.fqdn]
}