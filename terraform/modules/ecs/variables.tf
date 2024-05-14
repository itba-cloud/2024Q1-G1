variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "execution_role_arn" {
  description = "ARN of the IAM role for ECS task execution"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the IAM role for ECS tasks"
  type        = string
}
 
variable "task_family" {
  type        = string
  description = "Family of the ECS task definition"
}

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs for the ECS service"
}

variable "security_groups" {
  type        = list(string)
  description = "Security group IDs for the ECS service"
}

variable "repository_url" {
  type        = string
  description = "ECR repository URL"
}

variable "lb_dns_name" {
  type        = string
  description = "DNS name for the load balancer"
}

variable "db_endpoint" {
  type        = string
  description = "Database endpoint"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  description = "Database password"
}

variable "tg_arn" {
  type        = string
  description = "ARN of the target group for the load balancer"
}

variable "cpu_architecture" {
  type = string
  description = "Type of architecture the task will run (depend on which architecture is built)"
}

variable "ecs_log_group" {
  type = string
  description = "Cloudwatch log group"
}