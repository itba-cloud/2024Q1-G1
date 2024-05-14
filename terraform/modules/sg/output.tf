output "lb_security_group_id" {
  value = aws_security_group.lendaread_lb_sg.id
}

output "ecs_task_security_group_id" {
  value = aws_security_group.lendaread_api_task_sg.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
}

