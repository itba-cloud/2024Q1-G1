
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
    key = "error.html"
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
  acl = "public-read"
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

resource "aws_cloudfront_origin_access_identity" "spa_oai" {
  comment = "OAI for SPA Bucket"
}

resource "aws_cloudfront_distribution" "spa_distribution" {
  origin {
    domain_name = aws_s3_bucket.spa_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.spa_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.spa_oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "SPA CloudFront Distribution"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.spa_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}