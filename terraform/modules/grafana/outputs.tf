output "grafana_workspace_id" {
  description = "The ID of the Grafana workspace."
  value       = aws_grafana_workspace.grafana.id
}

output "grafana_workspace_url" {
  description = "The URL of the Grafana workspace."
  value       = aws_grafana_workspace.grafana.endpoint
}