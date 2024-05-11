resource "aws_ecr_repository" "lendaread-tf" {
  name                 = "lendaread-tf"  # Change this to your preferred repository name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

