resource "aws_ecs_cluster" "lendaread_cluster" {
  name = "lendaread_cluster" 
}

resource "aws_ecs_task_definition" "lendaread_api_task" {
  family                   = "lendaread-tasks"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name      = "lendaread-container"
      image     = "${aws_ecr_repository.lendaread_ecr.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        { name = "VITE_APP_BASE_PATH", value = "/webapp" },
        { name = "VITE_APP_BASE_URL", value = "http://3.213.137.227:8080" },
        { name = "DB_URL_ENV", value = "jdbc:postgresql://database-2.ct80qs8yuayi.us-east-1.rds.amazonaws.com:5432/" },
        { name = "DB_USERNAME_ENV", value = "postgres" },
        { name = "DB_PASSWORD_ENV", value = "132holastf" } 
      ]
    }
  ])
}

resource "aws_ecs_service" "lendaread_service" {
  name            = "lendaread_service"
  cluster         = aws_ecs_cluster.lendaread_cluster.id
  task_definition = aws_ecs_task_definition.lendaread_api_task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_public1.id, aws_subnet.subnet_public2.id]
    security_groups  = [aws_security_group.lendaread_api_task_sg.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecr_repository.lendaread_ecr,
    aws_ecs_task_definition.lendaread_api_task
  ]
}
