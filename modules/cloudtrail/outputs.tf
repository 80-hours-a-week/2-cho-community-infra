###############################################################################
# CloudTrail Module - Outputs
###############################################################################

output "trail_arn" {
  description = "CloudTrail ARN"
  value       = aws_cloudtrail.this.arn
}

output "trail_name" {
  description = "CloudTrail 이름"
  value       = aws_cloudtrail.this.name
}

output "cloudwatch_log_group_name" {
  description = "CloudTrail CloudWatch 로그 그룹 이름"
  value       = aws_cloudwatch_log_group.cloudtrail.name
}
