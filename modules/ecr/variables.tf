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

variable "additional_repositories" {
  description = "추가 ECR 리포지토리 이름 리스트"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
