output "alb_dns_name" {
  value = aws_lb.lendaread_alb.dns_name
}
output "rds_endpoint" {
  value = aws_db_instance.lendaread_db.endpoint
}

output "rds_username" {
  value = aws_db_instance.lendaread_db.username
}

output "rds_password" {
  value = aws_db_instance.lendaread_db.password
  sensitive = true
}
