
resource "aws_s3_bucket" "spa_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "spa_bucket_owner_controls" {
  bucket = aws_s3_bucket.spa_bucket.bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
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
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "PublicRead",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.spa_bucket.bucket}/*"
      }
    ]
  })
}

resource "null_resource" "build_and_deploy_spa" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      set -e
      echo "Setting environment variables"
      export VITE_APP_BASE_PATH='/'
      export VITE_API_BASE_URL='http://${var.alb}:8080'
      
      echo "Listing contents of the cloned repository"
      
      echo "Navigating to frontend directory"
      cd ../../LendARead2/frontend
      
      echo "Installing dependencies"
      npm install
      
      echo "Building the SPA"
      npm run build
      
      echo "Syncing build output to S3"
      aws s3 sync dist/ s3://${aws_s3_bucket.spa_bucket.bucket} --delete --region ${var.region}

    EOF
  }

  depends_on = [
    aws_s3_bucket.spa_bucket
  ]
}
