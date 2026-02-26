###############################################################################
# S3 Module - Outputs
###############################################################################

# Frontend
output "frontend_bucket_id" {
  description = "프론트엔드 S3 버킷 ID"
  value       = aws_s3_bucket.frontend.id
}

output "frontend_bucket_arn" {
  description = "프론트엔드 S3 버킷 ARN"
  value       = aws_s3_bucket.frontend.arn
}

output "frontend_website_endpoint" {
  description = "S3 정적 웹사이트 엔드포인트"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "frontend_website_domain" {
  description = "S3 정적 웹사이트 도메인"
  value       = aws_s3_bucket_website_configuration.frontend.website_domain
}

# CloudTrail Logs
output "cloudtrail_logs_bucket_id" {
  description = "CloudTrail 로그 버킷 ID"
  value       = aws_s3_bucket.cloudtrail_logs.id
}

output "cloudtrail_logs_bucket_arn" {
  description = "CloudTrail 로그 버킷 ARN"
  value       = aws_s3_bucket.cloudtrail_logs.arn
}
