
terraform {

  backend "s3" {
    bucket         = "my-terraform-state-bucket-12561685120"
    key            = "terraform/state"
    region         = "us-east-1"
    encrypt        = true
  }

}