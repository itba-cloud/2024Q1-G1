module "ecr" {
  source             = "./modules/ecr"
  aws_region         = "us-east-1"
  repository_name    = "lendaread_ecr"
  image_tag_mutability = "MUTABLE"
}

module "ecs" {
  source         = "./modules/ecs"
  cluster_name   = "lendaread_cluster"
  task_family    = "lendaread-tasks"
  aws_region     = "us-east-1"
  subnets        = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]
  security_groups= [aws_security_group.lendaread_api_task_sg.id]
  repository_url = module.ecr.repository_url
  lb_dns_name    = aws_lb.lendaread_alb.dns_name
  db_endpoint    = aws_db_instance.lendaread_db.endpoint
  db_username    = aws_db_instance.lendaread_db.username
  db_password    = aws_db_instance.lendaread_db.password
  tg_arn         = aws_lb_target_group.lendaread_tg.arn
  execution_role_arn    = data.aws_iam_role.lab_role.arn
  task_role_arn         = data.aws_iam_role.lab_role.arn
}

