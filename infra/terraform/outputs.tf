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
# RDS Outputs
################################################################################

output "rds_endpoint" {
  description = "RDS endpoint (host:port)"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "RDS hostname"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.postgres.port
}

output "rds_database_name" {
  description = "RDS database name"
  value       = aws_db_instance.postgres.db_name
}

output "rds_username" {
  description = "RDS username"
  value       = aws_db_instance.postgres.username
  sensitive   = true
}

output "rds_secret_arn" {
  description = "ARN do secret com as credenciais do RDS"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "rds_secret_name" {
  description = "Nome do secret no Secrets Manager"
  value       = aws_secretsmanager_secret.rds_credentials.name
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
# IRSA Outputs
################################################################################

output "order_service_irsa_role_arn" {
  description = "ARN da IAM Role do Order Service"
  value       = module.order_service_irsa.iam_role_arn
}

output "order_service_irsa_role_name" {
  description = "Nome da IAM Role do Order Service"
  value       = module.order_service_irsa.iam_role_name
}