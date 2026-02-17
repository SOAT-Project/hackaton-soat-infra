resource "aws_ses_domain_identity" "main" {
	name   = "ses_domain_identity_${var.environment}"
	domain = var.ses_domain
}

resource "aws_ses_email_identity" "main" {
	email = var.ses_email_identity
}