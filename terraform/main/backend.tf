terraform {
  backend "s3" {
    bucket         = "bucket-wholly-uniformly-deeply-renewing-chipmunk"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dynamo"
  }
}
