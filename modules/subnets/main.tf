resource "aws_subnet" "public" {
  count             = length(var.availability_zones) * var.num_public_subnets
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(var.availability_zones, count.index % length(var.availability_zones))
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-public-${count.index + 1}"
  }, { "kubernetes.io/role/elb" = "1"}, { "kubernetes.io/cluster/${var.project_name}-${var.environment}" = "owned"})
}
resource "aws_subnet" "private" {
  count             = length(var.availability_zones) * var.num_private_subnets
  vpc_id            = var.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + var.num_public_subnets * length(var.availability_zones))
  availability_zone = element(var.availability_zones, count.index % length(var.availability_zones))
  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-private-${count.index + 1}"
   }, { "kubernetes.io/role/internal-elb" = "1"}, { "kubernetes.io/cluster/${var.project_name}-${var.environment}" = "owned"})
}

resource "aws_nat_gateway" "public" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public.*.id, count.index)
}

resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  domain   = "vpc"
}

resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = var.vpc_id
}

resource "aws_route" "private_route" {
  count                  = length(var.availability_zones)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public[count.index].id
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public.*.id)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = var.public_route_table_id
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private.*.id)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index % length(var.availability_zones))
}