resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "aws-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aws-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-public-subnet"
  }
}

resource "aws_subnet" "private_compute" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_compute_cidr[count.index]
  availability_zone = count.index == 0 ? var.az1 : var.az2

  tags = {
    Name = "aws-private-compute-${count.index}"
  }
}

resource "aws_subnet" "private_db" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_cidr[count.index]
  availability_zone = count.index == 0 ? var.az1 : var.az2

  tags = {
    Name = "aws-private-db-${count.index}"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "aws-nat-gw"
  }
}
