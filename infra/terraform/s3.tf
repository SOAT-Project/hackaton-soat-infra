resource "aws_s3_bucket" "hackaton-soat-web-bucket" {
	bucket = "hackaton-soat-web-${var.environment}"

	tags = {
		Name        = "hackaton-soat-web-${var.environment}"
		Environment = var.environment
		Project     = "soat"
	}
}

resource "aws_s3_bucket_acl" "hackaton-soat-web-bucket" {
  bucket = aws_s3_bucket.hackaton-soat-web-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "hackaton-soat-web-bucket" {
	bucket = aws_s3_bucket.hackaton-soat-web-bucket.id

	block_public_acls       = true
	block_public_policy     = true
	ignore_public_acls      = true
	restrict_public_buckets = true
}

resource "aws_s3_bucket" "hackaton-soat-content-bucket" {
	bucket = "hackaton-soat-content-bucket-${var.environment}"
	acl    = "private"

	tags = {
		Name        = "hackaton-soat-content-bucket-${var.environment}"
		Environment = var.environment
		Project     = "soat"
	}
}

resource "aws_s3_bucket_public_access_block" "hackaton-soat-content-bucket" {
	bucket = aws_s3_bucket.hackaton-soat-content-bucket.id

	block_public_acls       = true
	block_public_policy     = true
	ignore_public_acls      = true
	restrict_public_buckets = true
}

resource "aws_s3_bucket" "lambda_notification" {
  bucket = "hackaton-soat-lambda_notification-${var.environment}"
}

resource "aws_s3_bucket_versioning" "lambda_notification" {
  bucket = aws_s3_bucket.lambda_notification.id

  versioning_configuration {
    status = "Enabled"
  }
}