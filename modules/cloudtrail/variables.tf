###############################################################################
# CloudTrail Module - Variables
###############################################################################

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "cloudtrail_s3_bucket_id" {
  description = "CloudTrail 로그 저장용 S3 버킷 ID"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch 로그 보존 일수"
  type        = number
  default     = 90
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
