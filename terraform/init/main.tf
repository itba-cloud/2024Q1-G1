provider "aws" {
  region = var.aws_region
}

resource "random_pet" "bucket_suffix" {
  length    = 5
  separator = "-"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.bucket_name}-${random_pet.bucket_suffix.id}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.bucket

  versioning_configuration {
    status = "Enabled"
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
