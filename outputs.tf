output "id" {
  value = aws_cloudfront_distribution.cloudfront.id
}

output "arn" {
  value = aws_cloudfront_distribution.cloudfront.arn
}

output "hosted_zone_id" {
  value = aws_cloudfront_distribution.cloudfront.hosted_zone_id
}

output "domain_name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}

output "aliases" {
  value = aws_cloudfront_distribution.cloudfront.aliases
}

output "vpc_origin_ids" {
  description = "Map of VPC origin keys to their IDs"
  value       = { for k, v in aws_cloudfront_vpc_origin.vpc_origin : k => v.id }
}

output "vpc_origin_arns" {
  description = "Map of VPC origin keys to their ARNs"
  value       = { for k, v in aws_cloudfront_vpc_origin.vpc_origin : k => v.arn }
}
