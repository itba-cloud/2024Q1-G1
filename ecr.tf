resource "aws_ecr_repository" "lendaread_ecr" {
  name                 = "lendaread_ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

