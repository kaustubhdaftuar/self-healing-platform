resource "aws_sns_topic_subscription" "healer_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.healer.arn
}
