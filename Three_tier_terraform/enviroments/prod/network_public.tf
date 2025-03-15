# INTERNET GATEWAY 
resource "aws_internet_gateway" "public" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_vpc.main]
  tags = {
    Name         = "public-sub"
    "Enviroment" = var.enviroment_tag
  }
}
# NAT GATEWAY

resource "aws_eip" "eip_nat_0" {
  domain = "vpc"
  tags = {
    Name         = "nat_0"
    "Enviroment" = var.enviroment_tag
  }
}
resource "aws_eip" "eip_nat_1" {
  domain = "vpc"
  tags = {
    Name         = "nat_1"
    "Enviroment" = var.enviroment_tag
  }
}

resource "aws_nat_gateway" "nat_0" {
  allocation_id = aws_eip.eip_nat_0.id
  subnet_id     = aws_subnet.public_0.id
  tags = {
    Name         = "nat_gateway_0"
    "Enviroment" = var.enviroment_tag
  }
  depends_on = [aws_internet_gateway.public]
}
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.eip_nat_1.id
  subnet_id     = aws_subnet.public_1.id
  tags = {
    Name         = "nat_gateway_1"
    "Enviroment" = var.enviroment_tag
  }
  depends_on = [aws_internet_gateway.public]
}


# PUBLIC SUBNETS
resource "aws_subnet" "public_0" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_public_subnet_0
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"
  tags = {
    Name         = "public-sub"
    "Enviroment" = var.enviroment_tag
  }
  depends_on = [aws_vpc.main]
}

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_public_subnet_1
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1b"
  tags = {
    Name         = "public-sub"
    "Enviroment" = var.enviroment_tag
  }
  depends_on = [aws_vpc.main]
}

# PUBLIC ROUTE TABLE
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }
  depends_on = [aws_internet_gateway.public]
}

resource "aws_route_table_association" "public_0" {
  subnet_id      = aws_subnet.public_0.id
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_subnet.public_0, aws_route_table.public]

}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
  depends_on     = [aws_subnet.public_1, aws_route_table.public]

}

resource "aws_lb" "public-nlb" {
  name               = "public-nlb"
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb.id]
  subnets            = [aws_subnet.public_0.id, aws_subnet.public_1.id]
  depends_on         = [aws_security_group.nlb, aws_subnet.public_0, aws_subnet.public_1]

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true
  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_lb_target_group" "tg_public" {
  name        = "nlb-tg"
  port        = var.port_https
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  depends_on = [aws_vpc.main]
}

resource "aws_lb_listener" "tls_passthrough" {
  load_balancer_arn = aws_lb.public-nlb.id
  port              = var.port_https
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_public.arn
  }
  depends_on = [aws_lb.public-nlb, aws_lb_target_group.tg_public]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public-nlb.id
  port              = var.port_http
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_public.arn
  }

  depends_on = [aws_lb.public-nlb, aws_lb_target_group.tg_public]
}
