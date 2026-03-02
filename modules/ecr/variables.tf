###############################################################################
# ECR Module - Variables
###############################################################################

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "image_retention_count" {
  description = "유지할 최대 이미지 수"
  type        = number
  default     = 10
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
