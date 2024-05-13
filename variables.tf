variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name for cluster running tasks"
  type = string
  default = "lendaread_cluster"
}

variable "task_family" {
  description = "Name for task family"
  type = string
  default = "lendaread-tasks"
}

variable "ecr_name" {
  description = "Name of ECR"
  type = string
  default = "lendaread_ecr"
}

variable "ecr_mutability" {
  description = "Mutability of ECR"
  type = string
  default = "MUTABLE"
}

variable "alb_name" {
  description = "ALB name"
  type = string
  default = "lendaread-alb"
}

variable "alb_tg" {
  description = "ALB target group"
  type = string
  default = "lendaread-tg"
}

variable "alb_health_path" {
  description = "ALB Health Path"
  type = string
  default = "/"
}

variable "role" {
  description = "Role for ECS"
  type = string
}