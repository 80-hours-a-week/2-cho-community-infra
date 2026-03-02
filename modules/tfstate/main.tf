###############################################################################
# Terraform Remote State Module
# S3 버킷(상태 저장) + DynamoDB 테이블(상태 잠금)
###############################################################################

# -----------------------------------------------------------------------------
# S3 Bucket — Terraform 상태 파일 저장
# 상태 버킷은 환경 공유 리소스이므로 환경 이름을 포함하지 않음
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.project}-tfstate"

  tags = merge(var.tags, {
    Name = "${var.project}-tfstate"
  })
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 상태 파일에 민감 정보(RDS 엔드포인트, ARN 등) 포함 — 퍼블릭 접근 차단 필수
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  # noncurrent_version_expiration은 versioning 활성화 후에만 유효
  depends_on = [aws_s3_bucket_versioning.tfstate]

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    filter {}

    # Versioning으로 누적되는 이전 상태 파일을 90일 후 정리
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }

  rule {
    id     = "abort-incomplete-multipart"
    status = "Enabled"

    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# -----------------------------------------------------------------------------
# DynamoDB Table — Terraform 상태 잠금
# 동시 terraform apply 방지 (환경별 LockID가 다르므로 단일 테이블 공유 가능)
# -----------------------------------------------------------------------------
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.tags, {
    Name = "terraform-locks"
  })
}
