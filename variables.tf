variable "acm_arn" {
  description = "ACM cert arn"
  type        = string
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

variable "ipv6" {
  description = "ipv6 status"
  type        = bool
  default     = false
}