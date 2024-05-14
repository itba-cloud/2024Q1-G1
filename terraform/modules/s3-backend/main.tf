/*resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-12561685120"

  lifecycle {
    prevent_destroy = true
  }
}*/


output "s3_bucket" {
  value = aws_s3_bucket.terraform_state.bucket
}


variable "region" {
  description = "The AWS region where the S3 bucket and DynamoDB table will be created."
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for state locking."
  type        = string
}
