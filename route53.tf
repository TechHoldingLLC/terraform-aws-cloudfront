resource "aws_route53_record" "cloudfront" {
  count   = length(var.route53_zone_id) > 0 ? length(var.domain_aliases) : 0
  zone_id = var.route53_zone_id
  name    = element(var.domain_aliases, count.index)
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cloudfront.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront.hosted_zone_id
    evaluate_target_health = true
  }
  lifecycle {
    prevent_destroy = true
  }
}