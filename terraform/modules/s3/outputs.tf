output "bucket_id" {
  value = aws_s3_bucket.spa_bucket.id
}

output "bucket_name" {
  value = aws_s3_bucket.spa_bucket.bucket
}