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

