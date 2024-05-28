variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes."
  type        = number
}

variable "engine" {
  description = "The type of the database engine to be used."
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine to use."
  type        = string
}

variable "username" {
  description = "Username for the database administrator."
  type        = string
}

variable "password" {
  description = "Password for the database administrator."
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "A list of VPC Subnet IDs to create in the DB Subnet Group."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the RDS instance."
  type        = list(string)
}

variable "multi_az_rds" {
  description = "Boolean to mark whether multiple AZ RDS is configured"
  type = bool
}