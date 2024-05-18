resource "aws_s3_bucket" "spa_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "spa_bucket_owner_controls" {
  bucket = aws_s3_bucket.spa_bucket.bucket

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_website_configuration" "spa_website" {
  bucket = aws_s3_bucket.spa_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_policy" "spa_bucket_policy" {
  bucket = aws_s3_bucket.spa_bucket.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "PublicRead",
        "Effect": "Allow",
        "Principal": "*",
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.spa_bucket.bucket}/*"
      }
    ]
  })
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
    aws_s3_bucket.spa_bucket,
    aws_s3_bucket_ownership_controls.spa_bucket_owner_controls
  ]
}
