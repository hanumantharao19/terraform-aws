resource "aws_vpc" "dev-vpc" {
  cidr_block       = "192.165.0.0/16"


  tags = {
    Name = "dev-vpc"
  }
}


resource "aws_subnet" "dev-public-subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "192.165.20.0/24"

  tags = {
    Name = "dev-pub-subnet"
  }
}

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "dev-routable" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }


  tags = {
    Name = "dev-public-routetable"
  }
}

resource "aws_route_table_association" "dev-routable-associate" {
  subnet_id      = aws_subnet.dev-public-subnet.id
  route_table_id = aws_route_table.dev-routable.id
}

