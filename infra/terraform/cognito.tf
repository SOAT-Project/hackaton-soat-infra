
resource "aws_cognito_user_pool" "default" {
	name                = "soat-user-pool-${var.environment}"
	username_attributes = ["email"]
	auto_verified_attributes = ["email"]
	alias_attributes    = ["nickname"]
	mfa_configuration   = "OFF"
	password_policy {
		minimum_length    = 8
		require_uppercase = false
		require_lowercase = false
		require_numbers   = false
		require_symbols   = false
		temporary_password_validity_days = 7
	}
	account_recovery_setting {
		recovery_mechanism {
			name     = "verified_email"
			priority = 1
		}
	}
	admin_create_user_config {
		allow_admin_create_user_only = false
	}
	verification_message_template {
		email_message = "Clique no link para verificar seu email: {####}"
		email_subject = "Verificação de Email SOAT"
		sms_message   = "Seu código de verificação SOAT é {####}"
	}
	user_pool_add_ons {
		advanced_security_mode = "OFF"
	}
}

resource "aws_cognito_user_pool_client" "default" {
	name         = "soat-user-pool-client-${var.environment}"
	user_pool_id = aws_cognito_user_pool.default.id
	generate_secret = false
	allowed_oauth_flows_user_pool_client = true
	explicit_auth_flows = [
		"ALLOW_USER_PASSWORD_AUTH",
		"ALLOW_REFRESH_TOKEN_AUTH",
		"ALLOW_USER_SRP_AUTH",
		"ALLOW_CUSTOM_AUTH"
	]
	supported_identity_providers = ["COGNITO"]
	prevent_user_existence_errors = true
	supported_identity_providers = ["COGNITO"]

	callback_urls = [
		aws_cloudfront_distribution.frontend.domain_name != null ? "https://${aws_cloudfront_distribution.frontend.domain_name}/" : "",
		aws_cloudfront_distribution.frontend.domain_name != null ? "https://${aws_cloudfront_distribution.frontend.domain_name}/silent-renew.html" : ""
	]
	logout_urls = [
		aws_cloudfront_distribution.frontend.domain_name != null ? "https://${aws_cloudfront_distribution.frontend.domain_name}/" : ""
	]
	
	ui_customization {
		user_pool_id = aws_cognito_user_pool.default.id
		client_id    = aws_cognito_user_pool_client.default.id
		image_url    = null
		css = <<CSS
			body { background-color: #181818; color: #f1f1f1; }
			input, button { background-color: #222; color: #fff; }
			a { color: #4f8cff; }
			@media (prefers-color-scheme: light) {
				body { background-color: #fff; color: #222; }
				input, button { background-color: #f1f1f1; color: #222; }
				a { color: #0056b3; }
			}
		CSS
	}
}
