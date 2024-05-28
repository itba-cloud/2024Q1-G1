

resource "aws_grafana_workspace" "grafana" {
  account_access_type = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type = "SERVICE_MANAGED"
  role_arn = var.role_arn

  data_sources = ["CLOUDWATCH"]
  name = var.grafana_workspace_name
}


