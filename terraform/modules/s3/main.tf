resource "aws_s3_bucket" "spa_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "spa_bucket" {
  bucket = aws_s3_bucket.spa_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.spa_bucket,
    aws_s3_bucket_public_access_block.spa_bucket
  ]
}

resource "aws_s3_bucket_policy" "spa_bucket_policy" {
  bucket = aws_s3_bucket.spa_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccessOnly"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.cloudfront_origin_access_identity_id}"
        }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.spa_bucket.arn}/*"
      }
    ]
  })
}

resource "null_resource" "spa_bucket_deploy" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<-EOF
      export VITE_APP_BASE_PATH='/'
      export VITE_API_BASE_URL="https://${var.cloudfront_domain}"


      Set-Location -Path "../../LendARead2/frontend"

      npm install

      npm run build

      aws s3 sync dist/ "s3://${aws_s3_bucket.spa_bucket.bucket}" --delete --region ${var.region}
    EOF
    interpreter = ["PowerShell", "-Command"]
  }


  depends_on = [
    aws_s3_bucket.spa_bucket,
    aws_s3_bucket_acl.spa_bucket,
    aws_s3_bucket_policy.spa_bucket_policy
  ]
}
