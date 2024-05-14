

resource "aws_ecs_cluster" "lendaread_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "lendaread_api_task" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = var.cpu_architecture
  }

  container_definitions = jsonencode([
    {
      name      = "lendaread-container"
      image     = "${var.repository_url}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      environment = [
        { name = "VITE_APP_BASE_PATH", value = "/webapp" },
        { name = "VITE_APP_BASE_URL", value = "http://${var.lb_dns_name}" },
        { name = "DB_URL_ENV", value = "jdbc:postgresql://${var.db_endpoint}/" },
        { name = "DB_USERNAME_ENV", value = var.db_username },
        { name = "DB_PASSWORD_ENV", value = var.db_password }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.ecs_log_group,
          awslogs-region        = var.aws_region,
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
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tg_arn
    container_name   = "lendaread-container"
    container_port   = 8080
  }

  depends_on = [
    aws_ecs_task_definition.lendaread_api_task
  ]
}

