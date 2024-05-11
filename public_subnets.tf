resource "aws_vpc" "lendaread_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Lendaread VPC"
  }
}

resource "aws_internet_gateway" "lendaread_gw" {
  vpc_id = aws_vpc.lendaread_vpc.id

  tags = {
    Name = "Lendaread Internet Gateway"
  }
}

# Public Subnets
resource "aws_subnet" "subnet_public1" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "subnet_public2" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet 2"
  }
}


# Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.lendaread_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lendaread_gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_rta1" {
  subnet_id      = aws_subnet.subnet_public1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rta2" {
  subnet_id      = aws_subnet.subnet_public2.id
  route_table_id = aws_route_table.public_route_table.id
}
