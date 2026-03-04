resource "aws_iam_role" "hackaton-soat-notification-lambda" {
	name = "lambda_notify_${var.environment}"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
			Action = "sts:AssumeRole"
			Effect = "Allow"
			Principal = {
				Service = "lambda.amazonaws.com"
			}
		}]
	})
}

resource "aws_iam_role_policy" "lambda_notify_policy" {
	name = "lambda_notify_policy_${var.environment}"
	role = aws_iam_role.hackaton-soat-notification-lambda.id

	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect = "Allow"
				Action = [
					"logs:CreateLogGroup",
					"logs:CreateLogStream",
					"logs:PutLogEvents"
				]
				Resource = "arn:aws:logs:*:*:*"
			},
			{
				Effect = "Allow"
				Action = [
					"sqs:ReceiveMessage",
					"sqs:DeleteMessage",
					"sqs:GetQueueAttributes"
				]
				Resource = aws_sqs_queue.hackaton_soat_notify.arn
			},
			{
				Effect = "Allow"
				Action = [
					"ses:SendEmail",
					"ses:SendRawEmail"
				]
				Resource = "*"
			}
		]
	})
}

resource "aws_lambda_function" "notify" {
  function_name = "hackaton-soat-notify-${var.environment}"
  role          = aws_iam_role.hackaton-soat-notification-lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  timeout       = 30

  s3_bucket = aws_s3_bucket.lambda_notification.id
  s3_key    = "notify/notify.zip"

  lifecycle {
    ignore_changes = [
      s3_key,
      s3_object_version
    ]
  }

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }
}

resource "aws_lambda_event_source_mapping" "notify_sqs" {
	event_source_arn = aws_sqs_queue.hackaton_soat_notify.arn
	function_name    = aws_lambda_function.notify.arn
	enabled          = true
	batch_size       = 10
}
