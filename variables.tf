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

variable "rds_instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
  default     = 20
}

variable "rds_engine" {
  description = "The type of database engine to use."
  type        = string
  default     = "postgres"
}

variable "rds_engine_version" {
  description = "The version of the database engine to use."
  type        = string
  default     = "16.1"
}

variable "rds_username" {
  description = "The username for the RDS instance."
  type        = string
  default     = "postgres"
}

variable "rds_password" {
  description = "The password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "rds_db_name" {
  description = "The name for the RDS instance."
  type        = string
  default     = "PostgreSQL Instance"
}

variable "ecs_task_cpu_architecture" {
  description = "cpu architecture for ecs task instance"
  type = string
}