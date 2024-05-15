variable "aws_region" {
  description = "The AWS region to use."
  type        = string
}

variable "bucket_name" {
  description = "The base name of the S3 bucket to store Terraform state."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking."
  type        = string
}