provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "mhr-main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "dev-t-vpc"
  }
}
resource "aws_subnet" "mhr-subnet" {
  vpc_id     = aws_vpc.mhr-main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "dev-t-subnet-1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.mhr-main.id

  tags = {
    Name = "dev-t-igw"
  }
}

resource "aws_route_table" "mhr-rt" {
  vpc_id     = aws_vpc.mhr-main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }


  tags = {
    Name = "dev-t-rt"
  }
}

resource "aws_route_table_association" "mhr-rta" {
  subnet_id      = aws_subnet.mhr-subnet.id
  route_table_id = aws_route_table.mhr-rt.id
}

