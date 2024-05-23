variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "aliases" {
  description = "CNAMEs (alternate domain names) for the distribution"
  type        = list(string)
  default     = []
}


variable "bucket_id" {
  description = "The id of the S3 bucket to deploy the SPA"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type=string
}