# modules/k8s_ec2/outputs.tf

output "master_public_ip" {
  description = "Master 노드 Elastic IP"
  value       = aws_eip.master.public_ip
}

output "master_private_ip" {
  description = "Master 노드 Private IP"
  value       = aws_instance.master.private_ip
}

output "worker_public_ips" {
  description = "Worker 노드 Public IP 리스트"
  value       = aws_instance.worker[*].public_ip
}

output "worker_private_ips" {
  description = "Worker 노드 Private IP 리스트"
  value       = aws_instance.worker[*].private_ip
}

output "master_instance_id" {
  description = "Master 노드 인스턴스 ID"
  value       = aws_instance.master.id
}

output "worker_instance_ids" {
  description = "Worker 노드 인스턴스 ID 리스트"
  value       = aws_instance.worker[*].id
}
