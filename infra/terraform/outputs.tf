################################################################################
# CloudFront Outputs
################################################################################

output "frontend_cloudfront_url" {
  description = "URL da distribuição CloudFront do front-end"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

################################################################################
# EKS Outputs
################################################################################

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = module.eks.cluster_endpoint
}

output "cluster_region" {
  description = "Região do cluster"
  value       = local.region
}

################################################################################
# SQS Outputs
################################################################################

output "sqs_queue_urls" {
  description = "URLs das filas SQS"
  value = {
    notify_queue_url = aws_sqs_queue.hackaton_soat_notify.url
    process_queue_url = aws_sqs_queue.hackaton_soat_process.url
    processed_queue_url = aws_sqs_queue.hackaton_soat_processed.url
  }
}

################################################################################
# Cognito Outputs
################################################################################

output "cognito_user_pool_id" {
  description = "ID do Cognito User Pool"
  value       = aws_cognito_user_pool.default.id
}

output "cognito_user_pool_arn" {
  description = "ARN do Cognito User Pool"
  value       = aws_cognito_user_pool.default.arn
}

output "cognito_user_pool_client_id" {
  description = "ID do Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.default.id
}

################################################################################
# API Gateway Outputs
################################################################################

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_api_gateway_rest_api.karpenter_api.id
}

output "api_gateway_endpoint" {
  description = "URL base do API Gateway"
  value       = aws_api_gateway_stage.default.invoke_url
}

output "api_gateway_authorizer_id" {
  description = "ID do Cognito Authorizer no API Gateway"
  value       = aws_api_gateway_authorizer.cognito.id
}

output "sqs_queue_names" {
  description = "Nomes das filas SQS"
  value = {
    notify_queue_name = aws_sqs_queue.hackaton_soat_notify.name
    process_queue_name = aws_sqs_queue.hackaton_soat_process.name
    processed_queue_name = aws_sqs_queue.hackaton_soat_processed.name
  }
}

output "sqs_queue_arns" {
  description = "ARNs das filas SQS"
  value = {
    notify_queue_arn = aws_sqs_queue.hackaton_soat_notify.arn
    notify_queue_dlq_arn = aws_sqs_queue.hackaton_soat_notify_dlq.arn
    process_queue_arn = aws_sqs_queue.hackaton_soat_process.arn
    process_queue_dlq_arn = aws_sqs_queue.hackaton_soat_process_dlq.arn
    processed_queue_arn = aws_sqs_queue.hackaton_soat_processed.arn
    processed_queue_dlq_arn = aws_sqs_queue.hackaton_soat_processed_dlq.arn
  }
}

################################################################################
# Config Map Template (para facilitar deploy do K8s)
################################################################################

output "k8s_configmap_data" {
  description = "Dados para o ConfigMap do K8s (copy/paste ready)"
  value = {
    AWS_REGION                   = local.region
    NOTIFY_QUEUE_URL             = aws_sqs_queue.hackaton_soat_notify.url
    NOTIFY_QUEUE_NAME            = aws_sqs_queue.hackaton_soat_notify.name
    PROCESS_QUEUE_URL            = aws_sqs_queue.hackaton_soat_process.url
    PROCESS_QUEUE_NAME           = aws_sqs_queue.hackaton_soat_process.name
    PROCESSED_QUEUE_URL          = aws_sqs_queue.hackaton_soat_processed.url
    PROCESSED_QUEUE_NAME         = aws_sqs_queue.hackaton_soat_processed.name
    APPLICATION_PORT             = "8080"
  }
}

output "aws_region" {
  description = "AWS Region"
  value       = var.aws_region
}

# outputs.tf da INFRA

output "oidc_provider_arn" {
  description = "ARN do OIDC Provider do EKS"
  value       = module.eks.oidc_provider_arn
}

################################################################################
# SES Outputs
################################################################################

output "ses_domain_identity_arn" {
  description = "ARN da identidade de domínio no SES"
  value       = aws_ses_domain_identity.main.arn
}

output "ses_email_identity_arn" {
  description = "ARN da identidade de e-mail no SES"
  value       = aws_ses_email_identity.main.arn
}

output "ses_domain_identity_name" {
  description = "Nome da identidade de domínio no SES"
  value       = aws_ses_domain_identity.main.domain
}