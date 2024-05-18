variable "bucket_name" {
  description = "The name of the S3 bucket to deploy the SPA"
  type        = string
}

variable "alb" {
  description = "The url of the application load balancer"
  type        = string
}

variable "role" {
  description = "Role for bucket"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}
