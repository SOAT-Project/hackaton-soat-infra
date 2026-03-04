# variables.tf

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "sa-east-1"
}

################################################################################
# SQS Variables
################################################################################

variable "sqs_visibility_timeout" {
  description = "Visibility timeout das filas SQS em segundos"
  type        = number
  default     = 300
}

variable "sqs_message_retention" {
  description = "Tempo de retenção de mensagens em segundos (4 dias)"
  type        = number
  default     = 345600
}

variable "sqs_dlq_retention" {
  description = "Tempo de retenção de mensagens na DLQ em segundos (14 dias)"
  type        = number
  default     = 1209600
}

variable "sqs_max_receive_count" {
  description = "Número máximo de tentativas antes de ir pra DLQ"
  type        = number
  default     = 3
}

################################################################################
# Application Variables
################################################################################

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "kubernetes_namespace" {
  description = "Namespace do K8s para o hackaton app"
  type        = string
  default     = "hackaton"
}

################################################################################
# SES Variables
################################################################################

variable "ses_domain" {
  description = "Domínio para verificação no SES"
  type        = string
  default     = "gmail.com"
}

variable "ses_email_identity" {
  description = "E-mail de envio para SES"
  type        = string
  default     = "matheus.17.desa@gmail.com"
}
