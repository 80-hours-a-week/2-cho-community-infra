###############################################################################
# Route 53 Module - Outputs
###############################################################################

output "zone_id" {
  description = "Route 53 호스팅 영역 ID"
  value       = data.aws_route53_zone.this.zone_id
}

output "zone_name" {
  description = "Route 53 호스팅 영역 이름"
  value       = data.aws_route53_zone.this.name
}
