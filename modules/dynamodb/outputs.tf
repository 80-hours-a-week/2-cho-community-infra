output "table_name" {
  description = "DynamoDB 테이블 이름"
  value       = aws_dynamodb_table.ws_connections.name
}

output "table_arn" {
  description = "DynamoDB 테이블 ARN"
  value       = aws_dynamodb_table.ws_connections.arn
}
