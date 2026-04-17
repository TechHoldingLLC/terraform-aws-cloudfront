resource "aws_cloudfront_vpc_origin" "vpc_origin" {
  for_each = var.vpc_origins

  vpc_origin_endpoint_config {
    name                   = each.value.name
    arn                    = each.value.arn
    http_port              = lookup(each.value, "http_port", 80)
    https_port             = lookup(each.value, "https_port", 443)
    origin_protocol_policy = lookup(each.value, "origin_protocol_policy", "https-only")

    origin_ssl_protocols {
      items    = lookup(each.value, "origin_ssl_protocols", ["TLSv1.2"])
      quantity = length(lookup(each.value, "origin_ssl_protocols", ["TLSv1.2"]))
    }
  }
}
