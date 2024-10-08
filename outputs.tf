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
