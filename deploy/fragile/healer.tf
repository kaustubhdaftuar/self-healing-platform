data "archive_file" "healer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../src/healer"
  output_path = "${path.module}/healer.zip"
}

resource "aws_lambda_function" "healer" {
  function_name = "${var.project_name}-healer"
  runtime       = "python3.10"
  handler       = "app.lambda_handler"

  filename         = data.archive_file.healer_zip.output_path
  source_code_hash = data.archive_file.healer_zip.output_base64sha256

  role = aws_iam_role.healer_role.arn

  environment {
    variables = {
      TARGET_FUNCTION_NAME = aws_lambda_function.this.function_name
    }
  }

  depends_on = [data.archive_file.healer_zip]
}
