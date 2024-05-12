resource "aws_ecr_repository" "lendaread_ecr" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability


  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "docker_image" {
  depends_on = [aws_ecr_repository.lendaread_ecr]

  provisioner "local-exec" {
    command = <<EOF
    aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.lendaread_ecr.repository_url}
    docker build -t ${aws_ecr_repository.lendaread_ecr.repository_url}:latest .
    docker push ${aws_ecr_repository.lendaread_ecr.repository_url}:latest
    EOF
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

