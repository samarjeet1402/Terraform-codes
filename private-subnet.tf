# Configuration section for private subnet
resource "aws_subnet" "private_subnet_az_a" {
  count = length(var.private_subnet_cidr_az_a)

  cidr_block        = element(var.private_subnet_cidr_az_a, count.index)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone[0]

  tags = merge(
    {
      "Name" = format(
        "${var.environment_name}-${var.private_subnet_interfix}-a-${count.index}",
      )
    },
    var.additional_tags
  )
}

# Configuration section for route table private subnet
resource "aws_route_table" "private_subnet_az_a" {
  count = length(var.private_subnet_cidr_az_a)

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format(
        "${var.environment_name}-${var.private_subnet_interfix}-a-${count.index}",
      )
    },
    var.additional_tags
  )
}

# Configuration section for route table association on private route table AZ a
resource "aws_route_table_association" "private_subnet_az_a" {
  count = length(var.private_subnet_cidr_az_a)

  subnet_id      = element(aws_subnet.private_subnet_az_a[*].id, count.index)
  route_table_id = aws_route_table.private_subnet_az_a[0].id
}
# Configuration section for default route to internet from private subnet AZ a
resource "aws_route" "default_route_private_subnet_a" {
  route_table_id         = aws_route_table.private_subnet_az_a[0].id
  destination_cidr_block = var.default_route
  nat_gateway_id         = aws_nat_gateway.nat_gateway_a.id
}