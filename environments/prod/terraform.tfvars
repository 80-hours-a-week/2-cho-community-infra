###############################################################################
# Prod Environment - Variable Values
###############################################################################

# General
aws_region  = "ap-northeast-2"
project     = "my-community"
environment = "prod"

# IAM
admin_username       = "admin"
create_deployer_role = true

# VPC (prod: AZ별 NAT Gateway)
vpc_cidr           = "10.2.0.0/16"
az_count           = 2
single_nat_gateway = false

bastion_allowed_cidrs = []

# S3 / CloudTrail
cloudtrail_log_retention_days = 90

# Route 53 + ACM
domain_name     = "my-community.shop"
api_domain_name = "api.my-community.shop"

# ECR
ecr_image_retention_count = 20

# RDS (prod: 고사양 + Multi-AZ)
rds_engine_version        = "8.0"
rds_instance_class        = "db.t3.medium"
rds_allocated_storage     = 50
rds_max_allocated_storage = 200
rds_multi_az              = true
rds_backup_retention_days = 14
rds_deletion_protection   = true

# DB 자격 증명 (terraform apply 시 -var 또는 secret.tfvars로 전달)
db_name     = "community_service"
db_username = "admin"
# db_password → secret.tfvars

# EC2 (Bastion)
bastion_instance_type = "t3.micro"

# K8s 클러스터
create_k8s_cluster = true
# k8s_ssh_key_name, k8s_allowed_ssh_cidrs → secret.tfvars
