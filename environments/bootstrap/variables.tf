###############################################################################
# Bootstrap Environment - Variables
###############################################################################

variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "project" {
  description = "프로젝트 이름"
  type        = string
}

variable "environment" {
  description = "환경 이름"
  type        = string
}
