# Cloudfront
Below is an examples of calling this module.

## Cloudfront distribution with S3 origin
```
module "cloudfront" {
  source = "./cloudfront"
  origin = {
    domain_name = "s3_bucket_regional_domain_name"
    origin_id   = "s3_bucket_name"
    ## We can not use the Origin Access Control and Origin Access Identity togather
    # For Origin Access Control
    origin_access_control_id = "s3_cloudfront_origin_access_control_id"
    # For Origin Access Identity
    s3_origin_config = {
      s3_origin_access_identity = "s3_cloudfront_origin_access_identity_path"
    }
  }
  domain_aliases = ["example.com", "www.example.com"]
  acm_arn        = "acm_arn"
}
```

## Cloudfront distribution with custom http and https origin endpoint
```
module "cloudfront" {
  source     = "./cloudfront"
  origin = {
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