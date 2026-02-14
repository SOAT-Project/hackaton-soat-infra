variable "ses_domain" {
	description = "Domínio para verificação no SES"
	type        = string
}

variable "ses_email_identity" {
	description = "E-mail de envio para SES"
	type        = string
}

resource "aws_ses_domain_identity" "main" {
	domain = var.ses_domain
}

resource "aws_ses_email_identity" "main" {
	email = var.ses_email_identity
}