provider "aws" {
  region = var.aws_region
}

data "aws_iam_role" "lab_role" {
  name = var.role
}

module "ecr" {
  source               = "../modules/ecr"
  aws_region           = var.aws_region
  repository_name      = var.ecr_name
  image_tag_mutability = var.ecr_mutability
  api_base_url = module.cloudfront.cloudfront_domain_name
}

module "ecs" {
  source             = "../modules/ecs"
  cluster_name       = var.cluster_name
  task_family        = var.task_family
  aws_region         = var.aws_region
  subnets            = [module.vpc.subnet_private1, module.vpc.subnet_private2]
  security_groups    = [module.security_groups.ecs_task_security_group_id]
  repository_url     = module.ecr.repository_url
  lb_dns_name        = module.cloudfront.cloudfront_domain_name
  db_endpoint        = module.rds.db_endpoint
  db_username        = module.rds.db_username
  db_password        = module.rds.db_password
  tg_arn             = module.alb.tg_arn
  execution_role_arn = data.aws_iam_role.lab_role.arn
  task_role_arn      = data.aws_iam_role.lab_role.arn
  cpu_architecture   = var.ecs_task_cpu_architecture
  ecs_log_group      = module.cloudwatch.ecs_log_group
}

module "alb" {
  source            = "../modules/alb"
  vpc_id            = module.vpc.vpc_id
  alb_sg            = module.security_groups.lb_security_group_id
  public_subnets    = [module.vpc.subnet_public1, module.vpc.subnet_public2]
  alb_name          = var.alb_name
  target_group_name = var.alb_tg
  health_check_path = var.alb_health_path
}

module "rds" {
  source                 = "../modules/rds"
  instance_class         = var.rds_instance_class
  allocated_storage      = var.rds_allocated_storage
  engine                 = var.rds_engine
  engine_version         = var.rds_engine_version
  username               = var.rds_username
  password               = var.rds_password
  subnet_ids             = [module.vpc.subnet_db1, module.vpc.subnet_db2]
  vpc_security_group_ids = [module.security_groups.rds_security_group_id]
  multi_az_rds           = false
}

module "security_groups" {
  source = "../modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source              = "../modules/vpc"
  availability_zone_1 = format("%s%s", var.aws_region, "a")
  availability_zone_2 = format("%s%s", var.aws_region, "b")
}

module "cloudwatch" {
  source       = "../modules/cloudwatch"
  ecs_log_name = "/ecs/${var.task_family}"
}

module "spa" {
  source                  = "../modules/s3/"
  alb                     = module.alb.alb_dns_name
  bucket_name             = var.s3_spa_prefix
  role                    = data.aws_iam_role.lab_role.arn
  region                  = var.aws_region

  cloudfront_domain = module.cloudfront.cloudfront_domain_name
  cloudfront_origin_access_identity_id   = module.cloudfront.cloudfront_origin_access_identity_id
  operating_system  = var.operating_system
}

module "cloudfront" {
  source          = "../modules/cloudfront"
  s3_bucket_name  = module.spa.bucket_name
  aliases         = var.cloudfront_aliases
  aws_region      = var.aws_region
  bucket_id       = module.spa.bucket_id
  alb_dns_name    = module.alb.alb_dns_name
}

output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}
