creation sequence
# configuration
resource "aws_vpc" "main" {
  # ...
}

resource "aws_subnet" "public" {
  # ...
}

resource "aws_subnet" "private" {
  # ...
}

resource "aws_internet_gateway" "main" {
  # ...
}

resource "aws_nat_gateway" "main" {
  # ...
}

resource "aws_route_table" "public" {
  # ...
}

resource "aws_route_table" "private" {
  # ...
}