module "ecr" {
  source               = "./modules/ecr"
  aws_region           = "us-east-1"
  repository_name      = "lendaread_ecr"
  image_tag_mutability = "MUTABLE"
}

module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = "lendaread_cluster"
  task_family        = "lendaread-tasks"
  aws_region         = "us-east-1"
  subnets            = [aws_subnet.subnet_private1.id, aws_subnet.subnet_private2.id]
  security_groups    = [module.security_groups.ecs_task_security_group_id] # Adjusted
  repository_url     = module.ecr.repository_url
  lb_dns_name        = module.alb.alb_dns_name
  db_endpoint        = module.rds.db_endpoint
  db_username        = module.rds.db_username
  db_password        = module.rds.db_password
  tg_arn             = module.alb.tg_arn
  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn
}

module "alb" {
  source            = "./modules/alb"
  vpc_id            = aws_vpc.lendaread_vpc.id
  alb_sg            = module.security_groups.lb_security_group_id
  public_subnets    = [aws_subnet.subnet_public1.id, aws_subnet.subnet_public2.id]
  alb_name          = "lendaread-alb"
  target_group_name = "lendaread-tg"
  health_check_path = "/"
  tags = {
    Name = "lendaread-alb"
  }
}

module "rds" {
  source                 = "./modules/rds"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.1"
  username               = "postgres"
  password               = "132holastf#"
  subnet_ids             = [aws_subnet.subnet_db1.id, aws_subnet.subnet_db2.id]
  vpc_security_group_ids = [module.security_groups.rds_security_group_id] # Adjusted
  tags = {
    Name = "My PostgreSQL Instance"
  }
}

module "security_groups" {
  source = "./modules/sg"
  vpc_id = aws_vpc.lendaread_vpc.id
  tags = {
    Environment = "Production"
  }
}

