###############################################################################
# ACM Module - Variables
###############################################################################

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
}

variable "domain_name" {
  description = "인증서 도메인 이름"
  type        = string
}

variable "subject_alternative_names" {
  description = "SAN (Subject Alternative Names) 목록"
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Route 53 호스팅 영역 ID (DNS 검증용)"
  type        = string
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
