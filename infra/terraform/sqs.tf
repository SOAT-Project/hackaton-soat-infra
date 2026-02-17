# sqs.tf

################################################################################
# SQS Queues
################################################################################

# STANDARD: hackaton-soat-notify
resource "aws_sqs_queue" "hackaton_soat_notify_dlq" {
  name                      = "${local.name}-hackaton-soat-notify-dlq"
  message_retention_seconds = var.sqs_dlq_retention

  tags = merge(local.tags, {
    Name        = "${local.name}-hackaton-soat-notify-dlq"
    Environment = var.environment
  })
}

resource "aws_sqs_queue" "hackaton_soat_notify" {
  name                       = "${local.name}-hackaton-soat-notify"
  visibility_timeout_seconds = var.sqs_visibility_timeout
  message_retention_seconds  = var.sqs_message_retention

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.hackaton_soat_notify_dlq.arn
    maxReceiveCount     = var.sqs_max_receive_count
  })

  tags = merge(local.tags, {
    Name        = "${local.name}-hackaton-soat-notify"
    Environment = var.environment
  })
}

# STANDARD: hackaton-soat-process
resource "aws_sqs_queue" "hackaton_soat_process_dlq" {
  name                      = "${local.name}-hackaton-soat-process-dlq"
  message_retention_seconds = var.sqs_dlq_retention

  tags = merge(local.tags, {
    Name        = "${local.name}-hackaton-soat-process-dlq"
    Environment = var.environment
  })
}

resource "aws_sqs_queue" "hackaton_soat_process" {
  name                       = "${local.name}-hackaton-soat-process"
  visibility_timeout_seconds = var.sqs_visibility_timeout
  message_retention_seconds  = var.sqs_message_retention

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.hackaton_soat_process_dlq.arn
    maxReceiveCount     = var.sqs_max_receive_count
  })

  tags = merge(local.tags, {
    Name        = "${local.name}-hackaton-soat-process"
    Environment = var.environment
  })
}

# STANDARD: hackaton-soat-processed
resource "aws_sqs_queue" "hackaton_soat_processed_dlq" {
  name                      = "${local.name}-hackaton-soat-processed-dlq"
  message_retention_seconds = var.sqs_dlq_retention

  tags = merge(local.tags, {
    Name        = "${local.name}-hackaton-soat-processed-dlq"
    Environment = var.environment
  })
}

resource "aws_sqs_queue" "hackaton_soat_processed" {
  name                       = "${local.name}-hackaton-soat-processed"
  visibility_timeout_seconds = var.sqs_visibility_timeout
  message_retention_seconds  = var.sqs_message_retention

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.hackaton_soat_processed_dlq.arn
    maxReceiveCount     = var.sqs_max_receive_count
  })

  tags = merge(local.tags, {
    Name        = "${local.name}-hackaton-soat-processed"
    Environment = var.environment
  })
}

################################################################################
# IAM Policy para acesso ao SQS
################################################################################

resource "aws_iam_policy" "hackaton_sqs_policy" {
  name        = "${local.name}-sqs-policy"
  description = "Policy para acesso às filas SQS do hackaton"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility"
        ]
        Resource = [
          aws_sqs_queue.hackaton_soat_notify.arn,
          aws_sqs_queue.hackaton_soat_notify_dlq.arn,
          aws_sqs_queue.hackaton_soat_process.arn,
          aws_sqs_queue.hackaton_soat_process_dlq.arn,
          aws_sqs_queue.hackaton_soat_processed.arn,
          aws_sqs_queue.hackaton_soat_processed_dlq.arn
        ]
      }
    ]
  })

  tags = merge(local.tags, {
    Environment = var.environment
  })
}