
resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.project_name}_Role_Lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name        = "${var.project_name}_Policy_Lambda"
  path        = "/"
  description = "Lambda execution policy for project ${var.project_name} "

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogDelivery",
                "logs:CreateLogStream",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}