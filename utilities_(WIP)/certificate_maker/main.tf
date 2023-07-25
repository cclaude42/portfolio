resource "aws_acm_certificate" "static_certificate" {
  provider = aws.global

  domain_name               = var.domain_name
  subject_alternative_names = var.aliases
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
