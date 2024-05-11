# Security Group for ECS tasks
resource "aws_security_group" "lendaread_api_task_sg" {
  name        = "lendaread_api_sg"
  description = "Security group for ECS tasks to allow traffic on port 8080"
  vpc_id      = aws_vpc.lendaread_vpc.id

  # Inbound rules
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules - Allow all outbound traffic by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECS Task Security Group"
  }
}

# Security Group for RDS that only allows traffic from the ECS task security group
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance to allow access from ECS tasks"
  vpc_id      = aws_vpc.lendaread_vpc.id

  ingress {
    from_port       = 5432  # PostgreSQL default port
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lendaread_api_task_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}

