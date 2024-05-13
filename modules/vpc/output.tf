output "vpc_id" {
  value = aws_vpc.lendaread_vpc.id
}

output "subnet_db" {
  value = [aws_subnet.subnet_db1.id, aws_subnet.subnet_db2.id]
}

output "subnet_public" {
  value = [aws_subnet.subnet_public1.id, aws_subnet.subnet_public2.id]
}

output "subnet_private" {
  value = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]
}