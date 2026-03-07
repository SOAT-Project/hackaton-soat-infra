################################################################################
# IAM Policies - Hackaton Soat Processor
################################################################################

resource "aws_iam_policy" "hackaton-soat-processor" {
  name        = "${local.name}-hackaton-soat-processor-sqs"
  description = "Policy para o hackaton-soat-processor acessar filas SQS"

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

  tags = local.tags
}

################################################################################
# IRSA Role - Hackaton Soat Processor
################################################################################

module "hackaton_soat_processor_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${local.name}-hackaton-soat-processor"

  role_policy_arns = {
    sqs     = aws_iam_policy.hackaton-soat-processor.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["hackaton-soat-processor:hackaton-soat-processor-sa"]
    }
  }

  tags = local.tags
}

################################################################################
# IAM Policy - Hackaton Soat Manager (SQS + S3 + DynamoDB)
################################################################################

resource "aws_iam_policy" "hackaton_soat_manager" {
  name        = "${local.name}-hackaton-soat-manager-policy"
  description = "Policy para hackaton-soat-manager acessar SQS, S3 e DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # DynamoDB
      {
        Sid    = "DynamoAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          aws_dynamodb_table.hackaton_soat_processing.arn,
          "${aws_dynamodb_table.hackaton_soat_processing.arn}/index/*"
        ]
      },

      # SQS
      {
        Sid    = "SqsAccess"
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
      },

      # S3
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.hackaton_soat_web_bucket.arn}/*"
      }
    ]
  })

  tags = local.tags
}

################################################################################
# IRSA Role - Hackaton Soat Manager
################################################################################

module "hackaton_soat_manager_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${local.name}-hackaton-soat-manager"

  role_policy_arns = {
    manager = aws_iam_policy.hackaton_soat_manager.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = [
        "hackaton-soat-manager:hackaton-soat-manager-sa"
      ]
    }
  }

  tags = local.tags

  depends_on = [
    aws_iam_policy.hackaton_soat_manager
  ]
}


################################################################################
# IAM Policies - Hackaton Soat Notification
################################################################################

resource "aws_iam_policy" "hackaton-soat-notification" {
  name        = "${local.name}-hackaton-soat-notification-sqs"
  description = "Policy para o hackaton-soat-notification acessar filas SQS"

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

  tags = local.tags
}

################################################################################
# IRSA Role - Hackaton Soat Notification
################################################################################

module "hackaton_soat_notification_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${local.name}-hackaton-soat-notification"

  role_policy_arns = {
    sqs     = aws_iam_policy.hackaton-soat-notification.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["hackaton-soat-notification:hackaton-soat-notification-sa"]
    }
  }

  tags = local.tags
}