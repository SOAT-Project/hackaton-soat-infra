
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
  # REMOVA O COUNT
  
  rest_api_id             = aws_api_gateway_rest_api.karpenter_api.id
  resource_id             = aws_api_gateway_resource.karpenter_resource.id
  http_method             = aws_api_gateway_method.karpenter_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  
  # Se o DNS não existir ainda, usamos um placeholder no formato AWS que o API Gateway aceita
  uri = "http://${local.envoy_dns != "" ? local.envoy_dns : "pending.sa-east-1.elb.amazonaws.com"}/karpenter"
  
  connection_type = "INTERNET"

  depends_on = [data.kubernetes_service_v1.envoy_gateway]
}

resource "aws_api_gateway_deployment" "karpenter_deployment" {
  rest_api_id = aws_api_gateway_rest_api.karpenter_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.karpenter_resource.id,
      aws_api_gateway_method.karpenter_method.id,
      # Usamos join para evitar erro se a lista estiver vazia
      join("", aws_api_gateway_integration.karpenter_integration[*].uri)
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  # Importante: o deployment só deve acontecer se a integração existir
  # Mas como queremos que o Terraform termine o apply, deixamos o depends_on
  depends_on = [aws_api_gateway_integration.karpenter_integration]
}

resource "aws_api_gateway_stage" "default" {
  rest_api_id   = aws_api_gateway_rest_api.karpenter_api.id
  deployment_id = aws_api_gateway_deployment.karpenter_deployment.id
  stage_name    = var.environment
}
 