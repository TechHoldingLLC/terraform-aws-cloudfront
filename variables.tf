variable "acm_arn" {
  description = "ACM cert arn"
  type        = string
  default     = ""
}

variable "allowed_methods" {
  description = "Allowed methods"
  type        = list(any)
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "Cached methods"
  type        = list(any)
  default     = ["GET", "HEAD"]
}

variable "custom_error_response" {
  description = "Custom error response"
  type        = list(any)
  default     = []
}

variable "compress" {
  description = "Compress file"
  type        = bool
  default     = false
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "domain_aliases" {
  description = "domain aliases"
  type        = list(string)
  default     = null
}

variable "enabled" {
  description = "Cloudfront state"
  type        = bool
  default     = true
}

variable "lambda_function_association" {
  description = "Lambda edge association"
  type        = list(any)
  default     = []
}

variable "function_association" {
  description = "Function association"
  type        = list(any)
  default     = []
}

variable "logging_config" {
  description = "Cloudfront logging config"
  type        = map(any)
  default     = {}
}

variable "origin" {
  description = "Origin configuration"
  type        = any
}

variable "route53_zone_id" {
  description = "Route53 zone id"
  type        = string
  default     = ""
}

variable "web_acl_id" {
  description = "WAF web ACL id"
  type        = string
  default     = ""
}

variable "comment" {
  type    = string
  default = " "
}

variable "cache_policy_id" {
  description = "AWS managed cache policy id"
  type        = string
  default     = ""
}

variable "http_version" {
  description = "HTTP version to be allowed"
  type        = string
  default     = "http2"
}

variable "is_ipv6_enabled" {
  description = "ipv6 status"
  type        = bool
  default     = false
}

variable "ttl_values" {
  description = "map of ttl variables"
  type        = map(any)
  default     = {}
}

variable "origin_request_policy_id" {
  description = "Unique identifier of the origin request policy that is attached to the behavior"
  type        = string
  default     = ""
}

variable "viewer_protocol_policy" {
  description = "the protocol that users can use to access the files in the origin, valid values are allow-all, https-only, or redirect-to-https."
  type        = string
  default     = "redirect-to-https"
}

variable "default_cache_behaviour_target_origin_id" {
  description = "Target origin ID for default cache behaviour"
  type        = string
}

variable "ordered_cache_behavior" {
  description = "List of ordered cache behaviour"
  type        = any
  default     = []
}

variable "default_cache_forwarded_values" {
  description = "forwarded values for default cache behavior"
  type        = any
  default     = {}
}

variable "put_default_root_object" {
  description = "flag for default s3 object on index.html"
  type        = bool
  default     = false
}

variable "default_root_object_content" {
  description = "Content for the default root object"
  type        = string
  default     = ""
}

variable "s3_bucket_name" {
  description = "s3 bucket name for flag"
  type        = string
  default     = ""
}