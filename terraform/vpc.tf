#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name"                                      = "eks-demo-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

resource "aws_subnet" "demo_subnet" {
  count = 3

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.demo_vpc.id

  tags = tomap({
    "Name"                   = "eks-demo-node",
    "kubernetes.io/role/elb" = "1",
  })
}

resource "aws_subnet" "private_demo_subnet" {
  vpc_id            = aws_vpc.demo_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  count             = length(var.private_subnets_cidr)
  cidr_block        = element(var.private_subnets_cidr, count.index)
  # count                   = 3
  # cidr_block              = "10.0.144.0/20"
  map_public_ip_on_launch = false

  tags = tomap({
    "Name"                                      = "eks-demo-node",
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

# resource "aws_subnet" "private_demo_subnet_2" {
#   vpc_id                  = aws_vpc.demo_vpc.id
#   availability_zone       = data.aws_availability_zones.available.names[count.index]
#   count                   = 3
#   cidr_block              = "10.0.20./24"
#   map_public_ip_on_launch = false

#   tags = tomap({
#     "Name"                                      = "eks-demo-node",
#     "kubernetes.io/cluster/${var.cluster-name}" = "shared",
#   })
# }
resource "aws_internet_gateway" "demo_internet_gateway" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "terraform-eks-demo"
  }
}

resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_internet_gateway.id
  }
}

resource "aws_route_table_association" "demo" {
  count = 3

  subnet_id      = aws_subnet.demo_subnet.*.id[count.index]
  route_table_id = aws_route_table.demo_route_table.id
}
