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
			},
			{
				Effect = "Allow"
				Action = [
					"cognito-idp:AdminGetUser"
				]
				Resource = "*"
			},
		]
	})
}