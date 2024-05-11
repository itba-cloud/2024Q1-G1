resource "aws_db_instance" "lendaread_db" {
  identifier        = "mydbinstance"
  instance_class    = "db.t3.micro"  
  allocated_storage = 20            
  subnet_ids = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]

  engine                  = "postgres"
  engine_version          = "13.3" 
  username                = "postgres"
  password                = "132htf#" 
  db_subnet_group_name    = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.task_security_group.id]

  multi_az                = false
  storage_type            = "gp2"
  skip_final_snapshot     = true 

  tags = {
    Name = "My PostgreSQL Instance"
  }
}
