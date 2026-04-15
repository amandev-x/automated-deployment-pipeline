locals {
  common = {
    "Project" : "Automated Deployment Pipeline",
    "Owner" : "Aman Dabral",
    "Environment" : "Development"
  }
}
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(local.common, {
    "Name" : "${var.project_name}-vpc"
  })
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(local.common, {
    "Name" : "${var.project_name}-igw"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = merge(local.common, {
    "Name" : "${var.project_name}-public_subnet"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = merge(local.common, {
    "Name" : "${var.project_name}-public_route_table"
  })
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_rtb_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}