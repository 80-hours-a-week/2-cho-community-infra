###############################################################################
# CloudFront Module
# S3 정적 웹사이트 앞단에 CDN + HTTPS + Clean URL 제공
###############################################################################

# -----------------------------------------------------------------------------
# CloudFront Function: Clean URL 리라이트
# /post_list → /post_list.html (S3는 rewrite 미지원, CloudFront Functions로 구현)
# -----------------------------------------------------------------------------
resource "aws_cloudfront_function" "url_rewrite" {
  name    = "${var.project}-${var.environment}-url-rewrite"
  runtime = "cloudfront-js-2.0"
  publish = true

  code = <<-EOF
    function handler(event) {
      var request = event.request;
      var uri = request.uri;

      // 클린 URL → 실제 HTML 파일 매핑 (프론트엔드 HTML_PATHS와 동기화)
      var routes = {
        '/':             '/${var.default_root_object}',
        '/main':         '/post_list.html',
        '/login':        '/user_login.html',
        '/signup':       '/user_signup.html',
        '/write':        '/post_write.html',
        '/detail':       '/post_detail.html',
        '/edit':         '/post_edit.html',
        '/password':     '/user_password.html',
        '/edit-profile': '/user_edit.html'
      };

      if (routes.hasOwnProperty(uri)) {
        request.uri = routes[uri];
        return request;
      }

      // 매핑에 없고 확장자가 없는 경로 → .html 추가 (정적 파일 제외)
      if (!uri.includes('.')) {
        request.uri = uri + '.html';
      }

      return request;
    }
  EOF
}

# -----------------------------------------------------------------------------
# CloudFront Distribution
# -----------------------------------------------------------------------------
resource "aws_cloudfront_distribution" "frontend" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.default_root_object
  aliases             = [var.domain_name]
  price_class         = var.price_class
  comment             = "${var.project}-${var.environment} frontend CDN"

  # S3 웹사이트 엔드포인트를 커스텀 오리진으로 사용
  # (OAC 대신 — S3 website hosting은 REST API가 아니므로 커스텀 오리진 필수)
  origin {
    domain_name = var.s3_website_endpoint
    origin_id   = "s3-website"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # S3 website는 HTTP만 지원
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-website"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    # Clean URL 리라이트 함수 연결
    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.url_rewrite.arn
    }

    min_ttl     = 0
    default_ttl = 86400    # 1일
    max_ttl     = 31536000 # 1년
  }

  # HTML 파일은 캐시 짧게 (배포 후 빠른 반영)
  ordered_cache_behavior {
    path_pattern           = "*.html"
    target_origin_id       = "s3-website"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 300  # 5분
    max_ttl     = 3600 # 1시간
  }

  # SSL 인증서 (us-east-1 리전의 ACM)
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # 커스텀 에러 페이지: SPA 라우팅 대신 로그인 페이지로 안내
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/${var.default_root_object}"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/${var.default_root_object}"
    error_caching_min_ttl = 10
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project}-${var.environment}-cdn"
  })
}

# -----------------------------------------------------------------------------
# Route 53: 커스텀 도메인 → CloudFront
# -----------------------------------------------------------------------------
resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
