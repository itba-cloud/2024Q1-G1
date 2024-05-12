variable "vpc_id" {
  description = "The VPC ID where the security groups will be created."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all security groups."
  type        = map(string)
  default     = {}
}

