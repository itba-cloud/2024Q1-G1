terraform {
  backend "s3" {
    bucket         = data.terraform_remote_state.resources.outputs.s3_bucket
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = data.terraform_remote_state.resources.outputs.dynamodb_table
  }
}
