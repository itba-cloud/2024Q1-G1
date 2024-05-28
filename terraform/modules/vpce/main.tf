resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids

  private_dns_enabled = true

  security_group_ids = [aws_security_group.ecr_endpoint_sg.id]
  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids

  private_dns_enabled = true

  security_group_ids = [aws_security_group.ecr_endpoint_sg.id]
  tags = {
    Name = "ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.subnet_ids

  private_dns_enabled = true

  security_group_ids = [aws_security_group.cloudwatch_logs_endpoint_sg.id]
  tags = {
    Name = "cloudwatch-logs-endpoint"
  }
}
