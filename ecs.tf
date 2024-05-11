resource "aws_cloudwatch_log_group" "lendaread_log_group" {
  name = "/ecs/lendaread"
  retention_in_days = 14
}

resource "aws_ecs_cluster" "lendaread_cluster" {
  name = "lendaread_cluster" 
}

resource "aws_ecs_task_definition" "lendaread_api_task" {
  family                   = "lendaread-tasks"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"  # 1 vCPU
  memory                   = "2048"  # 2 GiB
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "lendaread-container"
      image     = "${aws_ecr_repository.lendaread_ecr.repository_url}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        { name = "VITE_APP_BASE_PATH", value = "/webapp" },
        { name = "VITE_APP_BASE_URL", value = "http://${aws_lb.lendaread_alb.dns_name}" },
        { name = "DB_URL_ENV", value = "jdbc:postgresql://${aws_db_instance.lendaread_db.endpoint}/" },
        { name = "DB_USERNAME_ENV", value = "${aws_db_instance.lendaread_db.username}" },
        { name = "DB_PASSWORD_ENV", value = "${aws_db_instance.lendaread_db.password}" }  # Consider using AWS Secrets Manager for this
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.lendaread_log_group.name,
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "lendaread_service" {
  name            = "lendaread_service"
  cluster         = aws_ecs_cluster.lendaread_cluster.id
  task_definition = aws_ecs_task_definition.lendaread_api_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet_public1.id, aws_subnet.subnet_public2.id]
    security_groups  = [aws_security_group.lendaread_api_task_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lendaread_tg.arn
    container_name   = "lendaread-container"
    container_port   = 80
  }

  depends_on = [
    aws_ecr_repository.lendaread_ecr,
    aws_ecs_task_definition.lendaread_api_task
  ]
}
