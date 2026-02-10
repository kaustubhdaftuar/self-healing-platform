resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name        = "${var.project_name}-lambda-errors"
  alarm_description = "Alarm when Lambda errors are detected"

  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    FunctionName = aws_lambda_function.this.function_name
  }

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}
