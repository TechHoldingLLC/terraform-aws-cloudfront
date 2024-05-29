# Cloudfront
Below is an examples of calling this module.

## Cloudfront distribution with S3 origin
```
module "cloudfront" {
  source = "./cloudfront"
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
  source     = "./cloudfront"
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
  source = "./cloudfront"
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

  ## TTL(Time to Live) is the time in seconds that an object is in Cloudfront Cache.
  # If we pass these below values then it will be overwritten by default values.
  ttl_values = {
    min_ttl = 1         # min amount of time that you want objects to stay in cloudfront cache before it sends another request to origin
    max_ttl = 86900     # max amount of time that you want objects to stay in cloudfront cache before it sends another request to origin
    default_ttl = 3500  # default amount of time that you want objects to stay in cloudfront cache before it sends another request to origin
  }
}
```

## Cloudfront distribution with multiple origin and cache behavior
```
module "cloudfront" {
  source = "./cloudfront"
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