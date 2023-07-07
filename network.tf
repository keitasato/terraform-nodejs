# VPC
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet"
    Project = "${var.project}"
    Env     = "${var.environment}"
    Type    = "public"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet"
    Project = "${var.project}"
    Env     = "${var.environment}"
    Type    = "private"
  }
}

# Route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-public-route-table"
    Project = "${var.project}"
    Env     = "${var.environment}"
    Type    = "public"
  }
}

resource "aws_route_table_association" "public-route_table-association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public-subnet.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-route-table"
    Project = "${var.project}"
    Env     = "${var.environment}"
    Type    = "private"
  }
}

resource "aws_route_table_association" "private-route_table-association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private-subnet.id
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = "${var.project}"
    Env     = "${var.environment}"
  }
}

resource "aws_route" "public_route_table_igw_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}