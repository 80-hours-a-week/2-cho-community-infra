###############################################################################
# IAM Module - Variables
###############################################################################

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "admin_username" {
  description = "관리자 IAM 사용자 이름 (빈 문자열이면 생성 안 함)"
  type        = string
  default     = ""
}

variable "create_deployer_role" {
  description = "Terraform 배포용 IAM 역할 생성 여부"
  type        = bool
  default     = false
}


variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
