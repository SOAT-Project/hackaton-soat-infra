resource "aws_s3_bucket" "hackaton-soat-web-bucket" {
	bucket = "soat-hackaton-soat-web-${var.environment}"
	acl    = "private"

	tags = {
		Name        = "soat-hackaton-soat-web-${var.environment}"
		Environment = var.environment
		Project     = "soat"
	}
}

resource "aws_s3_bucket_public_access_block" "hackaton-soat-web-bucket" {
	bucket = aws_s3_bucket.hackaton-soat-web.id

	block_public_acls       = true
	block_public_policy     = true
	ignore_public_acls      = true
	restrict_public_buckets = true
}
