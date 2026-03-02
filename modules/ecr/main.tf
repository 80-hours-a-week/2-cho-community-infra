###############################################################################
# ECR Module
# 백엔드 Docker 이미지 레지스트리
###############################################################################

resource "aws_ecr_repository" "backend" {
  name                 = "${var.project}-${var.environment}-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-backend"
  })
}

# 이미지 수명 주기: 최근 N개만 유지 (스토리지 비용 관리)
resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.backend.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "태그 없는 이미지: 최근 ${var.image_retention_count}개만 유지"
        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = var.image_retention_count
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "태그된 이미지: latest 제외, 오래된 이미지 정리"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v", "build-", "sha-"]
          countType     = "imageCountMoreThan"
          countNumber   = var.image_retention_count
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
