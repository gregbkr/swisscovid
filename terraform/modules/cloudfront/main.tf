variable "dns_domain" {}
variable "bucket_domain" {}
variable "cert_arn" {}

# CLOUDFRONT DISTRIBUTION
locals {
  s3_origin_id = "S3-${var.dns_domain}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.bucket_domain
    origin_id   = local.s3_origin_id
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "My cloudfront"
  default_root_object = "index.html"

  aliases = ["${var.dns_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.cert_arn
    ssl_support_method = "sni-only"
  }
}

output "domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
output "hosted_zone_id" {
  value = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
}