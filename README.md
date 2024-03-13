## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_route53_record.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_arn"></a> [acm\_arn](#input\_acm\_arn) | ACM cert arn | `string` | n/a | no |
| <a name="input_allowed_methods"></a> [allowed\_methods](#input\_allowed\_methods) | Allowed methods | `list(any)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_cache_policy_id"></a> [cache\_policy\_id](#input\_cache\_policy\_id) | AWS managed cache policy id | `string` | `""` | no |
| <a name="input_cached_methods"></a> [cached\_methods](#input\_cached\_methods) | Cached methods | `list(any)` | <pre>[<br>  "GET",<br>  "HEAD"<br>]</pre> | no |
| <a name="input_comment"></a> [comment](#input\_comment) | n/a | `string` | `" "` | no |
| <a name="input_custom_error_response"></a> [custom\_error\_response](#input\_custom\_error\_response) | Custom error response | `list(any)` | `[]` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | Default root object | `string` | `"index.html"` | no |
| <a name="input_domain_aliases"></a> [domain\_aliases](#input\_domain\_aliases) | domain aliases | `list(string)` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Cloudfront state | `bool` | `true` | no |
| <a name="input_function_association"></a> [function\_association](#input\_function\_association) | Function association | `list(any)` | `[]` | no |
| <a name="input_http_version"></a> [http\_version](#input\_http\_version) | HTTP version to be allowed | `string` | `"http2"` | no |
| <a name="input_ipv6"></a> [ipv6](#input\_ipv6) | ipv6 status | `bool` | `false` | no |
| <a name="input_lambda_function_association"></a> [lambda\_function\_association](#input\_lambda\_function\_association) | Lambda edge association | `list(any)` | `[]` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | Cloudfront logging config | `map(any)` | `{}` | no |
| <a name="input_origin"></a> [origin](#input\_origin) | Origin configuration | `any` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Route53 zone id | `string` | `""` | no |
| <a name="input_web_acl_id"></a> [web\_acl\_id](#input\_web\_acl\_id) | WAF web ACL id | `string` | `""` | no |
| <a name="input_ttl_values"></a> [ttl\_values](#input\_ttl\_values) | ttl values | `map` | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudfront_arn"></a> [cloudfront\_arn](#output\_cloudfront\_arn) | n/a |
| <a name="output_cloudfront_id"></a> [cloudfront\_id](#output\_cloudfront\_id) | n/a |