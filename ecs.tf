resource "aws_ecs_cluster" "lendaread_cluster" {
  name = "lendaread_cluster" 
}

resource "aws_ecs_task_definition" "lendaread_api_task" {
  family                   = "lendaread-tasks"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"   # Specify the CPU units
  memory                   = "512"   # Specify the memory
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  task_role_arn         = data.aws_iam_role.lab_role.arn

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
    subnets          = ["aws_subnet.subnet_public1", "aws_subnet.subnet_public2"] 
    security_groups  = ["lendaread_api_task_sg"]           
    assign_public_ip = true
  }

  depends_on = [
    aws_ecr_repository.lendaread_ecr,
    aws_ecs_task_definition.lendaread_api_task
  ]
}

