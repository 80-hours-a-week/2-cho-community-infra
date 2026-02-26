###############################################################################
# CloudFront Module - Variables
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
  description = "CloudFront 커스텀 도메인 (예: my-community.shop)"
  type        = string
}

variable "s3_website_endpoint" {
  description = "S3 정적 웹사이트 엔드포인트 (버킷명.s3-website.리전.amazonaws.com)"
  type        = string
}

variable "s3_website_domain" {
  description = "S3 정적 웹사이트 도메인 (리전별 도메인)"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM 인증서 ARN (us-east-1 리전 필수)"
  type        = string
}

variable "zone_id" {
  description = "Route 53 호스팅 영역 ID"
  type        = string
}

variable "api_domain_name" {
  description = "API 도메인 (CORS 허용 오리진용)"
  type        = string
  default     = ""
}

variable "default_root_object" {
  description = "기본 루트 객체"
  type        = string
  default     = "user_login.html"
}

variable "price_class" {
  description = "CloudFront 가격 등급 (PriceClass_100 = 가장 저렴, 북미+유럽만)"
  type        = string
  default     = "PriceClass_200" # 아시아 포함
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
