###############################################################################
# EC2 Module - Outputs
###############################################################################

output "instance_id" {
  description = "Bastion 인스턴스 ID"
  value       = aws_instance.bastion.id
}

output "public_ip" {
  description = "Bastion Elastic IP"
  value       = aws_eip.bastion.public_ip
}

output "private_ip" {
  description = "Bastion 프라이빗 IP"
  value       = aws_instance.bastion.private_ip
}
