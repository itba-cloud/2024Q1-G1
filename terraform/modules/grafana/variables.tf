variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "grafana_workspace_name" {
  description = "The name of the Grafana workspace."
  type        = string
}

variable "role_arn" {
  description = "Role to define Grafana"
  type = string
}