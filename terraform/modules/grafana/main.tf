

resource "aws_grafana_workspace" "grafana" {
  account_access_type = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type = "SERVICE_MANAGED"
  role_arn = data.aws_iam_role.lab_role.arn

  data_sources = ["CLOUDWATCH"]
  name = var.grafana_workspace_name
}

output "grafana_workspace_id" {
  value = aws_grafana_workspace.grafana.id
}

output "grafana_workspace_url" {
  value = aws_grafana_workspace.grafana.endpoint
}
