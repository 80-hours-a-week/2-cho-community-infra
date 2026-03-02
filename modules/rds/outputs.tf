###############################################################################
# RDS Module - Outputs
###############################################################################

output "endpoint" {
  description = "RDS 엔드포인트 (host:port)"
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "RDS 호스트 주소"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "RDS 포트"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "데이터베이스 이름"
  value       = aws_db_instance.this.db_name
}

output "instance_id" {
  description = "RDS 인스턴스 ID"
  value       = aws_db_instance.this.id
}

output "arn" {
  description = "RDS 인스턴스 ARN"
  value       = aws_db_instance.this.arn
}
