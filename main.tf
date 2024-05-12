module "ecr" {
  source             = "./modules/ecr"
  aws_region         = "us-east-1"
  repository_name    = "lendaread_ecr"
  image_tag_mutability = "MUTABLE"
}

