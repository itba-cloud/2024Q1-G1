output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "The domain name of the CloudFront distribution"
}

output "cloudfront_origin_access_identity_id" {
  value       = aws_cloudfront_origin_access_identity.this.id
  description = "The ID of the CloudFront origin access identity"
}