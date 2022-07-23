resource "aws_cloudwatch_event_rule" "scheduler" {
  name                = "${var.project_name}_lambda_scheduler"
  description         = "Schedules the lambda"
  schedule_expression = "rate(5 hours)"
}

resource "aws_cloudwatch_event_target" "target" {
  rule      = aws_cloudwatch_event_rule.scheduler.name
  target_id = "${var.project_name}_event_target"
  arn       = aws_lambda_function.test_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduler.arn
}