###############################################################################
# IAM Module - Outputs
###############################################################################

output "admin_group_name" {
  description = "관리자 그룹 이름"
  value       = aws_iam_group.admin.name
}

output "developer_group_name" {
  description = "개발자 그룹 이름"
  value       = aws_iam_group.developer.name
}

output "admin_user_name" {
  description = "관리자 사용자 이름"
  value       = var.admin_username != "" ? aws_iam_user.admin[0].name : null
}

output "admin_user_arn" {
  description = "관리자 사용자 ARN"
  value       = var.admin_username != "" ? aws_iam_user.admin[0].arn : null
}

output "admin_initial_password" {
  description = "관리자 초기 비밀번호 (첫 로그인 시 변경 필수)"
  value       = var.admin_username != "" ? aws_iam_user_login_profile.admin[0].password : null
  sensitive   = true
}

output "terraform_deployer_role_arn" {
  description = "Terraform 배포자 역할 ARN"
  value       = var.create_deployer_role ? aws_iam_role.terraform_deployer[0].arn : null
}
