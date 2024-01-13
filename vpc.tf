resource "aws_vpc" "vpc_dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc_dev"
  }
}


##### Create pair of subnets (public and private)


resource "aws_subnet" "private_subnet_1" {
  vpc_id = aws_vpc.vpc_dev.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id = aws_vpc.vpc_dev.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.vpc_dev.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.vpc_dev.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
}

#### Create IGW

resource "aws_internet_gateway" "igw_dev" {
  vpc_id = aws_vpc.vpc_dev.id
  tags = {
    Name = "igw_dev"
  }
}

### create NAT

resource "aws_eip" "eip_dev" {
    domain = "vpc"
    tags = {
      Name = "eip_dev"
    }
}
resource "aws_nat_gateway" "nat_gw" {
  subnet_id = aws_subnet.public_subnet_1.id
  allocation_id = aws_eip.eip_dev.id
  tags = {
    Name = "nat_dev"
  }
}
#### create routetables
resource "aws_route_table" "public_Rt" {
  vpc_id = aws_vpc.vpc_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_dev.id
  }
  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table" "private_Rt" {
  vpc_id = aws_vpc.vpc_dev.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "NAT_dev_RouteTable"
  }
}
#### Route table assoicitaions

resource "aws_route_table_association" "public_rta_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_Rt.id
}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_Rt.id
}

resource "aws_route_table_association" "private_rta_1" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_Rt.id
}

resource "aws_route_table_association" "private_rta_2" {
  subnet_id = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_Rt.id
}