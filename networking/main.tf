provider "aws" {
  region = "us-east-1"
}

locals {
vpc_id = aws_vpc.this[0].id
create_vpc = var.create_vpc
}

resource "aws_vpc" "this" {
  count = local.create_vpc ? 1 : 0
  cidr_block                           = var.cidr
  instance_tenancy                     = var.instance_tenancy
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_dns_support                   = var.enable_dns_support
  
  tags = merge(
    { Name = var.vpc_name},
    var.tags
  )
}

### subnet ###

resource "aws_subnet" "public" {
  count = length(var.azs)
  availability_zone     =  element(var.azs, count.index)
  vpc_id                = local.vpc_id
  cidr_block            = var.public_subnets[count.index]

   tags = merge(
    { Name = var.public_subnet_names[count.index] }, # Convert the string into a map
    var.tags                                        # Merge with existing tags map
  )
}




resource "aws_route_table" "public" {

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = "${var.vpc_name}-public-rt"
    },
    var.tags,
    
  )
}


resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "this" {
  vpc_id = local.vpc_id

  tags = merge(
    { "Name" = "${var.vpc_name}-igw" },
    var.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_subnet" "private" {
  count = length(var.azs)
  availability_zone     =  element(var.azs, count.index)
  vpc_id                = local.vpc_id
  cidr_block            = var.private_subnets[count.index]

   tags = merge(
    { Name = var.private_subnet_names[count.index] }, # Convert the string into a map
    var.tags                                    # Merge with existing tags map
  )
}


resource "aws_route_table" "private" {

  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = "${var.vpc_name}-private-rt"
    },
    var.tags,
    
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat" {
  
  domain = "vpc"
  tags = merge({

    "Name" =  "${var.vpc_name}-ip"
    },
    var.tags,
   
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id

  tags = merge(
    {
      "Name" =  "${var.vpc_name}-nat-gateway"
      
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat_gateway" {

  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.this.id
  destination_cidr_block              = "0.0.0.0/0"

  timeouts {
    create = "5m"
  }
}



