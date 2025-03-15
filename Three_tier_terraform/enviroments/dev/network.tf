resource "aws_vpc" "main-dev" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "dev"
    environment = "dev"
  }
}

# PUBLIC CONFIGURATION
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main-dev.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "public"
    environment = "dev"
  }
  depends_on = [aws_vpc.main-dev]
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main-dev.id
  tags = {
    Name        = "igw"
    environment = "dev"
  }
  depends_on = [aws_vpc.main-dev]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main-dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name        = "public"
    environment = "dev"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_subnet.public, aws_route_table.public]
}

# PRIVATE CONFIGURATION
resource "aws_subnet" "private_0" {
  vpc_id            = aws_vpc.main-dev.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name        = "private_0"
    environment = "dev"
  }
  depends_on = [aws_vpc.main-dev]
}
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main-dev.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  tags = {
    Name        = "private_1"
    environment = "dev"
  }
  depends_on = [aws_vpc.main-dev]
}
resource "aws_route_table" "private" {
  vpc_id     = aws_vpc.main-dev.id
  depends_on = [aws_vpc.main-dev]
  tags = {
    Name        = "private"
    environment = "dev"
  }
}

resource "aws_route_table_association" "private_0" {
  subnet_id      = aws_subnet.private_0.id
  route_table_id = aws_route_table.private.id
  depends_on     = [aws_subnet.private_0, aws_route_table.private]

}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
  depends_on     = [aws_route_table.private, aws_subnet.private_1]
}
