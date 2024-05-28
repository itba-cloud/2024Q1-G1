resource "aws_cloudwatch_log_group" "lendaread_log_group" {
  name              = var.ecs_log_name
  retention_in_days = 14
}

