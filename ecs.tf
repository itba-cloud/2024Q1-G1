resource "aws_ecs_cluster" "lendaread-tf-cluster" {
  name = "lendaread-tf-cluster" 
}

resource "aws_ecs_task_definition" "lendaread-api" {
  family                   = "lendaread-tasks"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"   # Specify the CPU units
  memory                   = "512"   # Specify the memory

  container_definitions = jsonencode([
    {
      name      = "lendaread-container"
      image     = "${aws_ecr_repository.my_repository.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

