# DB Subnet Group for RDS
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}


# RDS Instance
resource "aws_db_instance" "lendaread_db" {
  identifier        = "mydbinstance"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = "13.3"
  username          = "postgres"
  password          = "132htf#"  # Consider using AWS Secrets Manager
  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  multi_az                = false
  storage_type            = "gp2"
  skip_final_snapshot     = true  # Set to false in production environments

  tags = {
    Name = "My PostgreSQL Instance"
  }
}


