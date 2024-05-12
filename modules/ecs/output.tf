output "ecs_service_name" {
  value       = aws_ecs_service.lendaread_service.name
  description = "Name of the ECS service"
}

output "ecs_cluster_id" {
  value       = aws_ecs_cluster.lendaread_cluster.id
  description = "ID of the ECS cluster"
}

