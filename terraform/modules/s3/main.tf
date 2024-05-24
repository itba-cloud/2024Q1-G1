resource "aws_s3_bucket" "spa_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id
  acl    = "public-read"
  depends_on = [
    aws_s3_bucket_ownership_controls.spa_bucket,
    aws_s3_bucket_public_access_block.spa_bucket
  ]
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.spa_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.spa_bucket.arn,
          "${aws_s3_bucket.spa_bucket.arn}/*",
        ]
      },
    ]
  })
  depends_on = [
    aws_s3_bucket_public_access_block.spa_bucket
  ]
}
resource "null_resource" "spa_bucket" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOF
      if [ "${var.operating_system}" != "windows" ]; then
        export VITE_APP_BASE_PATH='/'
        export VITE_API_BASE_URL="https://${var.cloudfront_domain}"
      else
        $env:VITE_APP_BASE_PATH = '/'
        $env:VITE_API_BASE_URL = "https://${var.cloudfront_domain}"
      fi

      cd ../../LendARead2/frontend

      npm install

      npm run build

      aws s3 sync dist/ "s3://${aws_s3_bucket.spa_bucket.bucket}" --delete --region ${var.region}
    EOF
    interpreter = ["bash", "-c"]
  }

  depends_on = [
    aws_s3_bucket.spa_bucket
  ]
}
