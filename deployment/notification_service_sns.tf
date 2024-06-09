resource "aws_sns_topic" "notification_service_sns_topic" {
  name = "notification_service_${random_string.suffix.result}"
}

resource "aws_sns_topic_subscription" "notification_service_sns_lambda_target" {
  topic_arn = aws_sns_topic.notification_service_sns_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.notification_publisher_lambda.arn
}

resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification_publisher_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification_service_sns_topic.arn
}