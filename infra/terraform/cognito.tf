
resource "aws_cognito_user_pool" "default" {
	name                = "soat-user-pool-${var.environment}"
	username_attributes = ["email"]
	auto_verified_attributes = ["email"]
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
	allowed_oauth_flows = ["code"]
  	allowed_oauth_scopes = ["email", "openid", "profile"]
  	allowed_oauth_flows_user_pool_client = true
	explicit_auth_flows = [
		"ALLOW_USER_PASSWORD_AUTH",
		"ALLOW_REFRESH_TOKEN_AUTH",
		"ALLOW_USER_SRP_AUTH",
		"ALLOW_CUSTOM_AUTH"
	]
	supported_identity_providers = ["COGNITO"]
	prevent_user_existence_errors = "ENABLED"
	
	callback_urls = [
		"https://${aws_cloudfront_distribution.frontend.domain_name}/",
		"https://${aws_cloudfront_distribution.frontend.domain_name}/silent-renew.html"
	]
	logout_urls = [
		"https://${aws_cloudfront_distribution.frontend.domain_name}/"
	]
}

resource "aws_cognito_user_pool_ui_customization" "default" {
  user_pool_id = aws_cognito_user_pool.default.id
  client_id    = aws_cognito_user_pool_client.default.id

  css = file("${path.module}/cognito-ui.css")
}
