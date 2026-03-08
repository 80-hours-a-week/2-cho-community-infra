###############################################################################
# DynamoDB Module
# WebSocket 연결 매핑 테이블
###############################################################################

resource "aws_dynamodb_table" "ws_connections" {
  name         = "${var.project}-${var.environment}-ws-connections"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "connection_id"

  attribute {
    name = "connection_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "N"
  }

  global_secondary_index {
    name            = "user_id-index"
    hash_key        = "user_id"
    projection_type = "ALL"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-ws-connections"
  })
}
