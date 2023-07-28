# Configuration section for Public Subnet
resource "aws_subnet" "public_subnet_az_a" {
  count = length(var.public_subnet_cidr_az_a)

  cidr_block        = element(var.public_subnet_cidr_az_a, count.index)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.availability_zone[0]

  tags = merge(
    {
      "Name" = format(
        "${var.environment_name}-${var.public_subnet_interfix}-a-${count.index}",
      )
    },
    var.additional_tags
  )
}
# Configuration section for route table public subnet
resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format(
        "${var.environment_name}-${var.public_subnet_interfix}",
      )
    },
    var.additional_tags
  )
}
# Configuration section for default route to internet from public subnet
resource "aws_route" "default_route_public_subnet" {
  route_table_id         = aws_route_table.public_subnet.id
  destination_cidr_block = var.default_route
  gateway_id             = aws_internet_gateway.internet_gateway.id
}
# Configuration section for route table association on public route table
resource "aws_route_table_association" "public_subnet_az_a" {
  count = length(var.public_subnet_cidr_az_a)

  subnet_id      = element(aws_subnet.public_subnet_az_a[*].id, count.index)
  route_table_id = aws_route_table.public_subnet.id
}