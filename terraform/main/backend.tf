terraform {
  backend "s3" {
    bucket         = "bucket-apparently-typically-thankfully-upright-coral"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dynamo"
  }
}
