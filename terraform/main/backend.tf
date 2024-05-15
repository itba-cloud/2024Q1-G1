terraform {
  backend "s3" {
    bucket         = "bucket-cloud-virtually-primarily-rationally-fit-sailfish"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dynamo-cloud"
  }
}
