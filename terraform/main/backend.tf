terraform {
  backend "s3" {
    bucket         = "bucket-fairly-completely-equally-main-satyr"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dynamo"
  }
}
