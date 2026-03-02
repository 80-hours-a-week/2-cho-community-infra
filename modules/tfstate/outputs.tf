###############################################################################
# Terraform Remote State Module - Outputs
###############################################################################

output "tfstate_bucket_id" {
  description = "Terraform 상태 S3 버킷 ID (backend 설정에 사용)"
  value       = aws_s3_bucket.tfstate.id
}

output "tfstate_bucket_arn" {
  description = "Terraform 상태 S3 버킷 ARN"
  value       = aws_s3_bucket.tfstate.arn
}

output "dynamodb_table_name" {
  description = "Terraform 상태 잠금 DynamoDB 테이블 이름 (backend 설정에 사용)"
  value       = aws_dynamodb_table.terraform_locks.name
}
