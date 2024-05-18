resource "aws_s3_bucket" "spa_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "null_resource" "build_and_deploy_spa" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      export VITE_APP_BASE_PATH='/webapp'
      export VITE_APP_BASE_URL='${var.alb}'
      git clone https://github.com/Marco444/LendARead2-AWS.git LendARead2-AWS/
      cd LendARead2-AWS/frontend
      npm install
      npm run build
      aws s3 sync build/ s3://${aws_s3_bucket.spa_bucket.bucket} --delete
    EOT
  }

  depends_on = [
    aws_s3_bucket.spa_bucket
  ]
}
