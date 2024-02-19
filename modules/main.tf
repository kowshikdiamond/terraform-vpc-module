# Define your VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "NewVPC"
  }
}

# Create public and private subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnet-${count.index}"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Associate public subnets with the default route table of the VPC and link to the Internet Gateway
resource "aws_route" "public_route" {
  count            = length(var.availability_zones)
  route_table_id   = aws_vpc.my_vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id       = aws_internet_gateway.my_igw.id
}

# Create a separate route table for private subnets
resource "aws_route_table" "private_rt" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.my_vpc.id
}

# Associate private subnets with their respective private route tables
resource "aws_route_table_association" "private_assoc" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
