
# Private Subnets
resource "aws_subnet" "subnet_private1" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "subnet_private2" {
  vpc_id            = aws_vpc.lendaread_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Private Subnet 2"
  }
}


# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip1" {
  domain = "vpc"
}

resource "aws_eip" "nat_eip2" {
  domain = "vpc"
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gateway1" {
  allocation_id = aws_eip.nat_eip1.id
  subnet_id     = aws_subnet.subnet_private1.id
  tags = {
    Name = "NAT Gateway 1"
  }
}

resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.nat_eip2.id
  subnet_id     = aws_subnet.subnet_private2.id
  tags = {
    Name = "NAT Gateway 2"
  }
}

# Route Tables for each private subnet
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.lendaread_vpc.id

  route {
    cidr_block   = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway1.id
  }

  tags = {
    Name = "Private Route Table 1"
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.lendaread_vpc.id

  route {
    cidr_block   = "0.0.0.0/0"
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

