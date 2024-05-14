resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "s3_bucket" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table" {
  value = aws_dynamodb_table.terraform_locks.name
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
