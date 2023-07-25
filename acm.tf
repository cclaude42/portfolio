# Fetch ACM certificate
data "aws_acm_certificate" "valid_certificate" {
  provider = aws.global

  domain   = var.domain_name
  statuses = ["ISSUED"]
}
