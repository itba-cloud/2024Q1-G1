# Private Subnets
resource "aws_subnet" "subnet_db1" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Databases Subnet 1"
  }
}

resource "aws_subnet" "subnet_db2" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Databases Subnet 2"
  }
}

# Route Tables for Database Subnets (Corrected to not include Internet Gateway)
resource "aws_route_table" "subnet_db1_route_table" {
  vpc_id = aws_vpc.lendaread_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_subnet.subnet_private1.id
  }

  tags = {
    Name = "Private Database Route Table 1"
  }
}

# Route Tables for Database Subnets (Corrected to not include Internet Gateway)
resource "aws_route_table" "subnet_db2_route_table" {
  vpc_id = aws_vpc.lendaread_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_subnet.subnet_private2.id
  }

  tags = {
    Name = "Private Database Route Table 2"
  }
}
resource "aws_route_table_association" "db_rta1" {
  subnet_id      = aws_subnet.subnet_db1.id
  route_table_id = aws_route_table.subnet_db_route_table1.id
}

resource "aws_route_table_association" "db_rta2" {
  subnet_id      = aws_subnet.subnet_db2.id
  route_table_id = aws_route_table.subnet_db_route_table2.id
}

