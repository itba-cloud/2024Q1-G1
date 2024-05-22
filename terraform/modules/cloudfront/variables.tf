variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "aliases" {
  description = "CNAMEs (alternate domain names) for the distribution"
  type        = list(string)
  default     = []
}

variable "aws_region" {
  description = "AWS region"
  type=string
}