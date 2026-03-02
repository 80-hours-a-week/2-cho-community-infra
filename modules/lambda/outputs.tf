###############################################################################
# Lambda Module - Outputs
###############################################################################

output "function_name" {
  description = "Lambda 함수 이름"
  value       = aws_lambda_function.backend.function_name
}

output "function_arn" {
  description = "Lambda 함수 ARN"
  value       = aws_lambda_function.backend.arn
}

output "invoke_arn" {
  description = "Lambda 호출 ARN (API Gateway 연동용)"
  value       = aws_lambda_function.backend.invoke_arn
}

output "role_arn" {
  description = "Lambda IAM 역할 ARN"
  value       = aws_iam_role.lambda.arn
}

output "log_group_name" {
  description = "CloudWatch 로그 그룹 이름"
  value       = aws_cloudwatch_log_group.lambda.name
}
