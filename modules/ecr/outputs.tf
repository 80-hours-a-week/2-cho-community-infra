###############################################################################
# ECR Module - Outputs
###############################################################################

output "repository_url" {
  description = "ECR 레포지토리 URL"
  value       = aws_ecr_repository.backend.repository_url
}

output "repository_arn" {
  description = "ECR 레포지토리 ARN"
  value       = aws_ecr_repository.backend.arn
}

output "repository_name" {
  description = "ECR 레포지토리 이름"
  value       = aws_ecr_repository.backend.name
}

output "registry_id" {
  description = "ECR 레지스트리 ID"
  value       = aws_ecr_repository.backend.registry_id
}
