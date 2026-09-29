locals {
  cloudwatch_logs_enabled = try(var.cloudwatch_access_logs.enabled, false)

  cloudwatch_log_group_name = coalesce(var.cloudwatch_access_logs.log_group_name, "/aws/cloudfront/${aws_cloudfront_distribution.cloudfront.id}")

  cloudwatch_log_group_arn = try(aws_cloudwatch_log_group.access_logs[0].arn, var.cloudwatch_access_logs.log_group_arn)
}

# CloudWatch Logs configuration
resource "aws_cloudwatch_log_group" "access_logs" {
  provider = aws.us_east_1
  count    = local.cloudwatch_logs_enabled && try(var.cloudwatch_access_logs.create_log_group, true) ? 1 : 0

  name              = local.cloudwatch_log_group_name
  retention_in_days = try(var.cloudwatch_access_logs.log_group_retention_days, 30)
}

# CloudWatch Log Resource Policy for Access Logs Delivery
resource "aws_cloudwatch_log_resource_policy" "access_logs_delivery" {
  provider = aws.us_east_1
  count    = local.cloudwatch_logs_enabled && try(var.cloudwatch_access_logs.create_log_group, true) ? 1 : 0

  policy_name = "cloudfront-${aws_cloudfront_distribution.cloudfront.id}-access-logs-delivery"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "${aws_cloudwatch_log_group.access_logs[0].arn}:log-stream:*"
      },
    ]
  })
}

# CloudWatch Log Delivery configuration for Access Logs
resource "aws_cloudwatch_log_delivery_source" "access_logs" {
  provider = aws.us_east_1
  count    = local.cloudwatch_logs_enabled ? 1 : 0

  name         = "cloudfront-${aws_cloudfront_distribution.cloudfront.id}-access-logs"
  log_type     = "ACCESS_LOGS"
  resource_arn = aws_cloudfront_distribution.cloudfront.arn
}

# CloudWatch Log Delivery Destination configuration for Access Logs
resource "aws_cloudwatch_log_delivery_destination" "access_logs" {
  provider = aws.us_east_1
  count    = local.cloudwatch_logs_enabled ? 1 : 0

  name          = "cloudfront-${aws_cloudfront_distribution.cloudfront.id}-access-logs-dest"
  output_format = try(var.cloudwatch_access_logs.output_format, "json")

  delivery_destination_configuration {
    destination_resource_arn = local.cloudwatch_log_group_arn
  }
}

# CloudWatch Log Delivery configuration for Access Logs
resource "aws_cloudwatch_log_delivery" "access_logs" {
  provider = aws.us_east_1
  count    = local.cloudwatch_logs_enabled ? 1 : 0

  delivery_source_name     = aws_cloudwatch_log_delivery_source.access_logs[0].name
  delivery_destination_arn = aws_cloudwatch_log_delivery_destination.access_logs[0].arn

  record_fields = length(try(var.cloudwatch_access_logs.record_fields, [])) > 0 ? var.cloudwatch_access_logs.record_fields : null

  depends_on = [aws_cloudwatch_log_resource_policy.access_logs_delivery]
}
