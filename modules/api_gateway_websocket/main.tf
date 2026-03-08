###############################################################################
# WebSocket API Gateway Module
# wss://ws.my-community.shop — WebSocket 연결 관리
###############################################################################

resource "aws_apigatewayv2_api" "websocket" {
  name                       = "${var.project}-${var.environment}-ws"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.type"
}

# -----------------------------------------------------------------------------
# Lambda Integration (모든 라우트가 같은 Lambda를 호출)
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_integration" "lambda" {
  api_id             = aws_apigatewayv2_api.websocket.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_invoke_arn
  integration_method = "POST"
}

# -----------------------------------------------------------------------------
# Routes: $connect, $disconnect, $default
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_route" "connect" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

# -----------------------------------------------------------------------------
# Stage (auto deploy)
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.websocket.id
  name        = var.environment
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 100
    throttling_rate_limit  = 50
  }
}

# -----------------------------------------------------------------------------
# Lambda Permission (API Gateway가 Lambda를 호출할 수 있도록)
# -----------------------------------------------------------------------------
resource "aws_lambda_permission" "websocket" {
  statement_id  = "AllowWebSocketAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*/*"
}

# -----------------------------------------------------------------------------
# Custom Domain (ws.my-community.shop)
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_domain_name" "websocket" {
  domain_name = var.ws_domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
}

resource "aws_apigatewayv2_api_mapping" "websocket" {
  api_id      = aws_apigatewayv2_api.websocket.id
  domain_name = aws_apigatewayv2_domain_name.websocket.id
  stage       = aws_apigatewayv2_stage.main.id
}

# Route 53 A 레코드
resource "aws_route53_record" "websocket" {
  zone_id = var.zone_id
  name    = var.ws_domain_name
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.websocket.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.websocket.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
