resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-function"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "python3.10"
  handler       = "app.lambda_handler"

  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  environment {
    variables = {
      FAILURE_RATE = var.failure_rate
    }
  }
}
