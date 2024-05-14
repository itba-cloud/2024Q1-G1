output "db_instance_id" {
  value = aws_db_instance.lendaread_db.id
}

output "db_endpoint" {
  value = aws_db_instance.lendaread_db.endpoint
}

output "db_username" {
  value = aws_db_instance.lendaread_db.username
}

output "db_password" {
  value     = aws_db_instance.lendaread_db.password
  sensitive = true
}

