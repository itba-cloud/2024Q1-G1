# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip1" {
  vpc = true
}

resource "aws_eip" "nat_eip2" {
  vpc = true
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

