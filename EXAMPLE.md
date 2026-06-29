# Cloudfront
Below is an examples of calling this module.

## Cloudfront distribution with S3 origin
```
module "cloudfront" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-cloudfront.git?ref=<TAG>"
  origin = [
    {
      domain_name = "s3_bucket_regional_domain_name"
      origin_id   = "s3_bucket_name"

      ## We can only use Any one of Origin Access Control or Origin Access Identity
      # For Origin Access Control
      origin_access_control_id = "s3_cloudfront_origin_access_control_id"
      # For Origin Access Identity
      s3_origin_config = {
        s3_origin_access_identity = "s3_cloudfront_origin_access_identity_path"
      }

    }
  ]
  domain_aliases = ["example.com", "www.example.com"]
  acm_arn        = "acm_arn"
}
```

## Cloudfront distribution with custom http and https origin endpoint
```
module "cloudfront" {
  source     = "git::https://github.com/TechHoldingLLC/terraform-aws-cloudfront.git?ref=<TAG>"
  origin = [
    {
      domain_name = "s3_bucket_regional_domain_name"
      origin_id   = "s3_bucket_name"

      ## for http endpoint
      custom_origin_config = {
        origin_protocol_policy = "http-only"
      }
      ## for https endpoint
      # custom_origin_config = {
      #  origin_protocol_policy = "https-only"
      # }

      ## We can restrict publically accessible endpoint by adding custom headers in request sends from cloudfront to custom origin endpoint and validate headers on origin endpoint side
      custom_header = [
        {
          name  = "Referer"
          value = "https://example.com"
        },
        {
          name  = "Referer"
          value = "https://www.example.com"
        }
      ]
    }
  ]

  domain_aliases = ["example.com", "www.example.com"]
  acm_arn        = "acm_arn"
  ## it's helpful to handle 404 to redirect on index.html with 200 response for read based build
  custom_error_response = [
    {
      error_caching_min_ttl = 300
      error_code            = 404
      response_code         = 200
      response_page_path    = "/index.html"
    }
  ]
}
```

## Cloudfront distribution with s3 Origin with TTL value
```
module "cloudfront" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-cloudfront.git?ref=<TAG>"
  origin = [
    {
      domain_name = "s3_bucket_regional_domain_name"
      origin_id   = "s3_bucket_name"

      ## We can only use Any one of Origin Access Control or Origin Access Identity
      # For Origin Access Control
      origin_access_control_id = "s3_cloudfront_origin_access_control_id"
      # For Origin Access Identity
      s3_origin_config = {
        s3_origin_access_identity = "s3_cloudfront_origin_access_identity_path"
      }

    }
  ]
  domain_aliases = ["example.com", "www.example.com"]
  acm_arn        = "acm_arn"

  ## TTL(Time to Live) is the time in seconds that you want object to stay in cloudfront cache.
  # If we pass these below values then it will be overwritten by default values.
  ttl_values = {
    min_ttl = 1         # min amount of time that you want objects to stay in cloudfront cache before it sends another request to origin
    max_ttl = 86900     # max amount of time that you want objects to stay in cloudfront cache before it sends another request to origin
    default_ttl = 3500  # default amount of time that you want objects to stay in cloudfront cache before it sends another request to origin
  }
}
```

## Cloudfront distribution with IPv6 enabled and custom domain

Setting `is_ipv6_enabled = true` lets CloudFront serve traffic over IPv6.
When a `route53_zone_id` is also provided, the module creates **both** records
for each alias: an `A` record (IPv4) and an `AAAA` record (IPv6). Both are
Route53 alias records pointing at the same CloudFront distribution.

```hcl
module "cloudfront" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-cloudfront.git?ref=<TAG>"

  origin = [
    {
      domain_name              = "s3_bucket_regional_domain_name"
      origin_id                = "s3_bucket_name"
      origin_access_control_id = "s3_cloudfront_origin_access_control_id"
    }
  ]

  domain_aliases  = ["example.com", "www.example.com"]
  acm_arn         = "acm_arn"
  route53_zone_id = "Z123456ABCDEF"

  ## Enable IPv6 on the distribution. The module will create A + AAAA
  ## alias records for each entry in domain_aliases.
  is_ipv6_enabled = true
}
```

## Cloudfront distribution with VPC origin (private ALB)

Use this when your ALB lives in a **private subnet** and has no public IP.
The module creates the `aws_cloudfront_vpc_origin` resource internally — you just reference it by key, which avoids a circular dependency.

```hcl
## resource "aws_lb" "private" { ... internal = true ... }

module "cloudfront" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-cloudfront.git?ref=<TAG>"

  ## Step 1 — declare the VPC origin(s) to be created by the module.
  vpc_origins = {
    alb = {
      name = "my-private-alb"
      arn = aws_lb.private.arn

      ## Ports the ALB listens on (defaults: 80 / 443).
      http_port  = 80
      https_port = 443

      origin_protocol_policy = "https-only"

      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  ## Step 2 — define the CloudFront origin that points at the VPC origin above.
  origin = [
    {

      domain_name = aws_lb.private.dns_name

      ## Any unique string that identifies this origin within the distribution.
      origin_id = "alb-vpc-origin"

      vpc_origin_config = {
        vpc_origin_key = "alb"
        origin_read_timeout = 30
        origin_keepalive_timeout = 5
      }
    }
  ]
}
```
## Cloudfront distribution with multiple origin and cache behavior
```
module "cloudfront" {
  source = "git::https://github.com/TechHoldingLLC/terraform-aws-cloudfront.git?ref=<TAG>"
  origin = [
    {
      domain_name = "domain_name"
      origin_id   = "origin_id"
    },
    {
      domain_name = "domain_name"
      origin_id   = "origin_id"
      origin_path = "/origin_path"
    }
  ]

  domain_aliases = ["example.com", "www.example.com"]
  acm_arn        = "acm_arn"

  default_cache_behaviour_target_origin_id = default_cache_behaviour_target_origin_id
  allowed_methods                          = ["list of allowed methods"]
  cache_policy_id                          = aws_managed_cache_policy_id

  ## Can be used only if cache_policy_id is not used
  # forwarded_values = {
  #   query_string            = true
  #   query_string_cache_keys = ["list of query string cache keys"]     # set only if query_string is true and not all query string are meant to be cached
  #   headers                 = ["list of headers"]                     # specify * to include all headers
  #   cookie_forward           = ""
  #   cookies_whitelisted_names = ["list of whitelisted cookie names"]  # specify only if cookie forward is set to whitelist
  # }

  ## Can be used only if cache_policy_id is not used
  # ttl_values = {
  #   min_ttl     = 0
  #   max_ttl     = 31536000
  #   default_ttl = 86400
  # }

  ordered_cache_behavior = [
    {
      path_pattern           = "path_pattern"
      target_origin_id       = origin_id

      ttl_values = {
        min_ttl     = 0
        max_ttl     = 31536000
        default_ttl = 86400
      }

      forwarded_values = {
        query_string = true
      }

      ## Used to associate a cloudfront_function
      function_association = [
        {
          event_type   = "event_type"
          function_arn = cloudfront_function_arn
        }
      ]

      ## Used to associate a lambda_function
      lambda_function_association = [
        {
          event_type   = "event_type"
          lambda_arn   = lambda_function_arn
          include_body = true
        }
      ]
    }
  ]
}
```
