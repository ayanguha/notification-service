resource "aws_iam_role" "execution_role_notification_publisher" {
  name               = "notification_publisher_${random_string.suffix.result}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "execution_policy_notification_publisher" {
  name = "notification_publisher_lambda_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ],
      Effect   = "Allow",
      Resource = "arn:aws:logs:*:*:*",
      },
      {
        "Sid" : "PublishSNSMessage",
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Resource" : aws_sns_topic.notification_service_sns_topic.arn
    }],
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_attach_notification_publisher" {
  role       = aws_iam_role.execution_role_notification_publisher.name
  policy_arn = aws_iam_policy.execution_policy_notification_publisher.arn
}

resource "aws_s3_bucket" "s3_notification_publisher" {
  bucket        = "notificationpublishers3${random_string.suffix.result}"
  force_destroy = true
}

data "archive_file" "notification_publisher" {
  type        = "zip"
  source_dir  = "../notification_publisher"
  output_path = "../target/notification_publisher.zip"
}

resource "aws_lambda_function" "notification_publisher_lambda" {
  filename      = "../target/notification_publisher.zip"
  function_name = "notification_publisher_lambda_${random_string.suffix.result}"
  role          = aws_iam_role.execution_role_notification_publisher.arn
  runtime       = "python3.12"
  handler       = "handler.lambda_handler"
  timeout       = 60
  source_code_hash = data.archive_file.notification_publisher.output_md5
  environment {
    variables = {
      target_sns_topic_arn = aws_sns_topic.notification_service_sns_topic.arn
    }
  }
}