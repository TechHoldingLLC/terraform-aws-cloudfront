#tfsec:ignore:aws-cloudfront-enable-logging
resource "aws_cloudfront_distribution" "cloudfront" {
  enabled         = var.enabled
  web_acl_id      = var.web_acl_id #tfsec:ignore:aws-cloudfront-enable-waf
  comment         = var.comment
  http_version    = var.http_version
  is_ipv6_enabled = var.is_ipv6_enabled

  dynamic "origin" {
    for_each = var.origin

    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = lookup(origin.value, "origin_path", "")

      dynamic "s3_origin_config" {
        for_each = length(keys(lookup(origin.value, "s3_origin_config", {}))) > 0 ? [lookup(origin.value, "s3_origin_config")] : []
        content {
          origin_access_identity = s3_origin_config.value.s3_origin_access_identity
        }
      }

      origin_access_control_id = length(lookup(origin.value, "origin_access_control_id", "")) > 0 ? lookup(origin.value, "origin_access_control_id") : null

      dynamic "custom_origin_config" {
        for_each = length(lookup(origin.value, "custom_origin_config", "")) > 0 ? [lookup(origin.value, "custom_origin_config")] : []
        content {
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          http_port              = lookup(custom_origin_config.value, "http_port", 80)
          https_port             = lookup(custom_origin_config.value, "https_port", 443)
          origin_ssl_protocols   = lookup(custom_origin_config.value, "origin_ssl_protocols", ["TLSv1.2"])
        }
      }

      dynamic "custom_header" {
        for_each = lookup(origin.value, "custom_header", [])
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.acm_arn == "" ? true : false
    acm_certificate_arn            = var.acm_arn == "" ? null : var.acm_arn
    ssl_support_method             = var.acm_arn == "" ? null : "sni-only"
    minimum_protocol_version       = var.acm_arn == "" ? null : "TLSv1.2_2021"
  }

  aliases             = var.domain_aliases
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods          = var.allowed_methods
    cached_methods           = var.cached_methods
    target_origin_id         = var.default_cache_behaviour_target_origin_id
    cache_policy_id          = var.cache_policy_id
    origin_request_policy_id = var.origin_request_policy_id

    viewer_protocol_policy = var.viewer_protocol_policy
    compress               = var.compress
    min_ttl                = lookup(var.ttl_values, "min_ttl", null)
    max_ttl                = lookup(var.ttl_values, "max_ttl", null)
    default_ttl            = lookup(var.ttl_values, "default_ttl", null)

    dynamic "forwarded_values" {
      for_each = var.cache_policy_id != "" ? [] : [1]

      content {
        query_string = false

        cookies {
          forward = "none"
        }
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.lambda_function_association
      content {
        event_type   = lambda_function_association.value.event_type
        lambda_arn   = lambda_function_association.value.lambda_arn
        include_body = lambda_function_association.value.include_body
      }
    }

    dynamic "function_association" {
      for_each = var.function_association
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior

    content {
      path_pattern = ordered_cache_behavior.value.path_pattern

      target_origin_id         = ordered_cache_behavior.value.target_origin_id
      allowed_methods          = lookup(ordered_cache_behavior.value, "allowed_methods", ["GET", "HEAD"])
      cached_methods           = lookup(ordered_cache_behavior.value, "cached_methods", ["GET", "HEAD"])
      cache_policy_id          = lookup(ordered_cache_behavior.value, "cache_policy_id", "")
      origin_request_policy_id = lookup(ordered_cache_behavior.value, "origin_request_policy_id", "")

      viewer_protocol_policy = lookup(ordered_cache_behavior.value, "viewer_protocol_policy", "redirect-to-https")
      compress               = lookup(ordered_cache_behavior.value, "compress", false)
      min_ttl                = lookup(ordered_cache_behavior.value.ttl_values, "min_ttl", null)
      max_ttl                = lookup(ordered_cache_behavior.value.ttl_values, "max_ttl", null)
      default_ttl            = lookup(ordered_cache_behavior.value.ttl_values, "default_ttl", null)

      dynamic "forwarded_values" {
        for_each = contains(keys(ordered_cache_behavior.value), "cache_policy_id") ? {} : ordered_cache_behavior.value.forwarded_values

        content {
          query_string            = lookup(forwarded_values.value, "query_string", false)
          query_string_cache_keys = lookup(forwarded_values.value, "query_string_cache_keys", [])
          headers                 = lookup(forwarded_values.value, "headers", [])

          cookies {
            forward           = lookup(forwarded_values.value, "cookies_forward", "none")
            whitelisted_names = lookup(forwarded_values.value, "cookies_whitelisted_names", [])
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = contains(keys(ordered_cache_behavior.value), "lambda_function_association") ? ordered_cache_behavior.value.lambda_function_association : []
        content {
          event_type   = lambda_function_association.value.event_type
          lambda_arn   = lambda_function_association.value.lambda_arn
          include_body = lambda_function_association.value.include_body
        }
      }

      dynamic "function_association" {
        for_each = contains(keys(ordered_cache_behavior.value), "function_association") ? ordered_cache_behavior.value.function_association : []
        content {
          event_type   = function_association.value.event_type
          function_arn = function_association.value.function_arn
        }
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_response
    content {
      error_code            = custom_error_response.value.error_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  dynamic "logging_config" {
    for_each = length(keys(var.logging_config)) > 0 ? [var.logging_config] : []
    content {
      bucket          = logging_config.value.bucket
      prefix          = logging_config.value.prefix
      include_cookies = logging_config.value.include_cookies
    }
  }
}
