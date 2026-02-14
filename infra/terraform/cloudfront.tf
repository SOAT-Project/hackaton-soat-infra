resource "aws_cloudfront_origin_access_control" "hackaton-soat-web-oac" {
	name                              = "soat-hackaton-soat-web-oac-${var.environment}"
	description                       = "OAC for SOAT hackaton-soat-web S3 bucket"
	origin_access_control_origin_type = "s3"
	signing_behavior                  = "always"
	signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "frontend" {
	enabled             = true
	default_root_object = "index.html"

	origin {
		domain_name              = aws_s3_bucket.hackaton-soat-web-bucket.bucket_regional_domain_name
		origin_id                = "soat-hackaton-soat-web-s3-${var.environment}"
		origin_access_control_id = aws_cloudfront_origin_access_control.hackaton-soat-web-oac.id
	}

	default_cache_behavior {
		allowed_methods  = ["GET", "HEAD", "OPTIONS"]
		cached_methods   = ["GET", "HEAD"]
		target_origin_id = "soat-hackaton-soat-web-s3-${var.environment}"

		forwarded_values {
			query_string = false
			cookies {
				forward = "none"
			}
		}

		viewer_protocol_policy = "redirect-to-https"
		min_ttl                = 0
		default_ttl            = 3600
		max_ttl                = 86400
	}

	price_class = "PriceClass_100"

	restrictions {
		geo_restriction {
			restriction_type = "none"
		}
	}

	viewer_certificate {
		cloudfront_default_certificate = true
	}

	tags = {
		Name        = "soat-hackaton-soat-web-cloudfront-${var.environment}"
		Environment = var.environment
		Project     = "soat"
	}
}
