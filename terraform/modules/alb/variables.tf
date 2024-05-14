variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the load balancer and security groups are to be created."
}

variable "public_subnets" {
  type        = list(string)
  description = "List of subnet IDs for the ALB to be attached to."
}

variable "alb_sg" {
  type        = string
  description = "Load Balancer Security Group"
}

variable "alb_name" {
  type        = string
  description = "Name of the Application Load Balancer."
}

variable "target_group_name" {
  type        = string
  description = "Name of the target group."
}

variable "health_check_path" {
  type        = string
  description = "Path used to check the health of the target."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

