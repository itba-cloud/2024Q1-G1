resource "aws_vpc" "lendaread_vpc" {
  cidr_block           = var.cidr_vpc
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

#############################################
############## Public Subnets ##############
#############################################
resource "aws_subnet" "subnet_public1" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        =  var.cidr_public_1
  availability_zone =  var.availability_zone_1

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "subnet_public2" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = var.cidr_public_2
  availability_zone = var.availability_zone_2

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

#############################################
############## Private Subnets ##############
#############################################

resource "aws_subnet" "subnet_private1" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = var.cidr_private_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "subnet_private2" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = var.cidr_private_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "Private Subnet 2"
  }
}


# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip1" {
}

resource "aws_eip" "nat_eip2" {
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateway1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = aws_subnet.subnet_public1.id
  tags = {
    Name = "NAT Gateway 1"
  }
}

resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = aws_subnet.subnet_public2.id
  tags = {
    Name = "NAT Gateway 2"
  }
}

# Route Tables for each private subnet
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.lendaread_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  tags = {
    Name = "Private Route Table 1"
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.lendaread_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway2.id
  }

  tags = {
    Name = "Private Route Table 2"
  }
}

# Associate route tables with subnets
resource "aws_route_table_association" "private_rta1" {
  subnet_id      = aws_subnet.subnet_private1.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "private_rta2" {
  subnet_id      = aws_subnet.subnet_private2.id
  route_table_id = aws_route_table.private_route_table2.id
}

#############################################
############## Dbs Subnets ##################
#############################################

resource "aws_subnet" "subnet_db1" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = var.cidr_db_1
  availability_zone = var.availability_zone_1

  tags = {
    Name = "Private Databases Subnet 1"
  }
}

resource "aws_subnet" "subnet_db2" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = var.cidr_db_2
  availability_zone = var.availability_zone_2

  tags = {
    Name = "Private Databases Subnet 2"
  }
}

# Route Tables for Database Subnets (Corrected to not include Internet Gateway)
resource "aws_route_table" "subnet_db1_route_table" {
  vpc_id = aws_vpc.lendaread_vpc.id

  tags = {
    Name = "Private Database Route Table 1"
  }
}

# Route Tables for Database Subnets (Corrected to not include Internet Gateway)
resource "aws_route_table" "subnet_db2_route_table" {
  vpc_id = aws_vpc.lendaread_vpc.id

  tags = {
    Name = "Private Database Route Table 2"
  }
}
resource "aws_route_table_association" "db_rta1" {
  subnet_id      = aws_subnet.subnet_db1.id
  route_table_id = aws_route_table.subnet_db1_route_table.id
}

resource "aws_route_table_association" "db_rta2" {
  subnet_id      = aws_subnet.subnet_db2.id
  route_table_id = aws_route_table.subnet_db2_route_table.id
}

