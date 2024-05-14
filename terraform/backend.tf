terraform {
  backend "s3" {
    bucket         = var.s3_backend_bucket_name
    key            = "terraform/state"
    region         = var.aws_region
    encrypt        = true
  }
}
