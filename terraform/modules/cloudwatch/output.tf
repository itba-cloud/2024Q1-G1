output "ecs_log_group" {
  value = aws_cloudwatch_log_group.lendaread_log_group.name
  description = ""
}