resource "aws_lambda_function" "healer" {
  function_name = "${var.project_name}-healer"
  runtime       = "python3.10"
  handler       = "app.lambda_handler"

  filename = var.use_artifacts
  ? "${path.module}/../../src/healer/healer.zip"
  : null

  source_code_hash = var.use_artifacts
  ? filebase64sha256("${path.module}/../../src/healer/healer.zip")
  : null

  role = aws_iam_role.healer_role.arn

  environment {
    variables = {
      TARGET_FUNCTION_NAME = aws_lambda_function.this.function_name
    }
  }
}
