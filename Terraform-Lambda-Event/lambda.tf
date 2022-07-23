resource "aws_lambda_function" "test_lambda" {
  filename      = var.zip_file
  function_name = "${var.project_name}_lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = filebase64sha256(var.zip_file)
  description      = "${var.project_name} - Updating RDS by calling API"
  runtime          = "python3.8"
  timeout          = 900
}