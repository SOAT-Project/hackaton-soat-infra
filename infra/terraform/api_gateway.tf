
resource "aws_api_gateway_rest_api" "karpenter_api" {
	name        = "karpenter-api-${var.environment}"
	description = "API Gateway para Karpenter Kubernetes, protegido pelo Cognito"
}

resource "aws_api_gateway_resource" "karpenter_resource" {
	rest_api_id = aws_api_gateway_rest_api.karpenter_api.id
	parent_id   = aws_api_gateway_rest_api.karpenter_api.root_resource_id
	path_part   = "karpenter"
}

resource "aws_api_gateway_method" "karpenter_method" {
	rest_api_id   = aws_api_gateway_rest_api.karpenter_api.id
	resource_id   = aws_api_gateway_resource.karpenter_resource.id
	http_method   = "ANY"
	authorization = "COGNITO_USER_POOLS"
	authorizer_id = aws_api_gateway_authorizer.cognito.id
	api_key_required = false
}

resource "aws_api_gateway_authorizer" "cognito" {
	name                   = "CognitoAuthorizer"
	rest_api_id            = aws_api_gateway_rest_api.karpenter_api.id
	identity_source        = "method.request.header.Authorization"
	type                   = "COGNITO_USER_POOLS"
	provider_arns          = [aws_cognito_user_pool.default.arn]
}

resource "aws_api_gateway_integration" "karpenter_integration" {
	rest_api_id             = aws_api_gateway_rest_api.karpenter_api.id
	resource_id             = aws_api_gateway_resource.karpenter_resource.id
	http_method             = aws_api_gateway_method.karpenter_method.http_method
	integration_http_method = "ANY"
	type                    = "HTTP_PROXY"
	uri                     = var.karpenter_url
}

resource "aws_api_gateway_deployment" "karpenter_deployment" {
	depends_on = [aws_api_gateway_integration.karpenter_integration]
	rest_api_id = aws_api_gateway_rest_api.karpenter_api.id
	stage_name  = "${var.environment}"
}

variable "karpenter_url" {
	description = "URL do endpoint do Karpenter no Kubernetes"
	type        = string
}
 