###############################################################################
# WebSocket Lambda Module
# $connect / $disconnect / $default 핸들러
###############################################################################

# -----------------------------------------------------------------------------
# IAM Role
# -----------------------------------------------------------------------------
resource "aws_iam_role" "websocket_lambda" {
  name = "${var.project}-${var.environment}-ws-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ws_lambda_basic" {
  role       = aws_iam_role.websocket_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# DynamoDB 접근 + API Gateway Management API 권한
resource "aws_iam_policy" "ws_lambda_policy" {
  name = "${var.project}-${var.environment}-ws-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query"
        ]
        Resource = [
          var.dynamodb_table_arn,
          "${var.dynamodb_table_arn}/index/*"
        ]
      },
      {
        # 순환 참조 방지를 위해 와일드카드 사용
        # execute-api:ManageConnections는 충분히 구체적인 액션
        Effect   = "Allow"
        Action   = "execute-api:ManageConnections"
        Resource = "arn:aws:execute-api:${var.aws_region}:*:*/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ws_lambda_policy" {
  role       = aws_iam_role.websocket_lambda.name
  policy_arn = aws_iam_policy.ws_lambda_policy.arn
}

# SSM 접근 (SECRET_KEY 조회 — JWT 검증용)
resource "aws_iam_policy" "ws_lambda_ssm" {
  name = "${var.project}-${var.environment}-ws-lambda-ssm"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ssm:GetParameter"]
        Resource = var.secret_key_ssm_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ws_lambda_ssm" {
  role       = aws_iam_role.websocket_lambda.name
  policy_arn = aws_iam_policy.ws_lambda_ssm.arn
}

# -----------------------------------------------------------------------------
# CloudWatch Log Group
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "ws_lambda" {
  name              = "/aws/lambda/${var.project}-${var.environment}-websocket"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# -----------------------------------------------------------------------------
# Lambda Function (ZIP 배포 — 경량 핸들러)
# -----------------------------------------------------------------------------
resource "aws_lambda_function" "websocket" {
  function_name = "${var.project}-${var.environment}-websocket"
  role          = aws_iam_role.websocket_lambda.arn

  runtime = "python3.11"
  handler = "handler.lambda_handler"

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  memory_size = 256
  timeout     = 30

  environment {
    variables = {
      DYNAMODB_TABLE      = var.dynamodb_table_name
      SECRET_KEY_SSM_NAME = var.secret_key_ssm_name
      WS_API_ENDPOINT     = var.ws_api_endpoint
      AUTH_TIMEOUT_SEC     = "10"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.ws_lambda_basic,
    aws_iam_role_policy_attachment.ws_lambda_policy,
    aws_iam_role_policy_attachment.ws_lambda_ssm,
    aws_cloudwatch_log_group.ws_lambda,
  ]

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-websocket"
  })
}
