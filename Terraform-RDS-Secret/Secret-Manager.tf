resource "aws_secretsmanager_secret" "api-key" {
  name = "api-key1"
}

resource "aws_secretsmanager_secret_version" "api-key" {
  secret_id     = aws_secretsmanager_secret.api-key.id
  secret_string = "api_key_001"
}

resource "aws_secretsmanager_secret" "rds-user" {
  name = "rds-user1"
}

resource "aws_secretsmanager_secret_version" "rds-user" {
  secret_id     = aws_secretsmanager_secret.rds-user.id
  secret_string = var.dbuser
}

resource "aws_secretsmanager_secret" "rds-password" {
  name = "rds-pass1"
}

resource "aws_secretsmanager_secret_version" "rds-password" {
  secret_id     = aws_secretsmanager_secret.rds-password.id
  secret_string = var.dbpassword
}