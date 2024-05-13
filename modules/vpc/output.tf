output "vpc_id" {
  value = aws_vpc.lendaread_vpc.id
}

output "subnet_db1" {
  value = aws_subnet.subnet_db1.id
}

output "subnet_db2" {
  value = aws_subnet.subnet_db2.id
}

output "subnet_public1" {
  value = aws_subnet.subnet_public1.id
}

output "subnet_public2" {
  value = aws_subnet.subnet_public2.id
}

output "subnet_private1" {
  value = aws_subnet.subnet_private1.id
}

output "subnet_private2" {
  value = aws_subnet.subnet_private2.id
}