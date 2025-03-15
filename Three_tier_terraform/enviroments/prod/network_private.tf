# VPC CONFIG
resource "aws_vpc" "main" {
  cidr_block = var.base_cidr_block
  tags = {
    Name         = "main-tf"
    "Enviroment" = var.enviroment_tag
  }
}
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  depends_on = [aws_vpc.main]
  tags = {
    Name = "default"
  }
}


# PRIVATE SUBNETS APP

resource "aws_subnet" "private_app_0" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_private_app_0_subnet
  map_public_ip_on_launch = false
  tags = {
    Name         = "private_app_0"
    "Enviroment" = var.enviroment_tag
  }
}

resource "aws_subnet" "private_app_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_private_app_1_subnet
  map_public_ip_on_launch = false
  tags = {
    Name         = "private_app_1"
    "Enviroment" = var.enviroment_tag
  }
}

# ROUTE TABLES PRIVATE APP

resource "aws_route_table" "private_app_0" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_vpc.main]
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_0.id
  }
}
resource "aws_route_table" "private_app_1" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_vpc.main]
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
}

resource "aws_route_table_association" "private_app_0" {
  subnet_id      = aws_subnet.private_app_0.id
  route_table_id = aws_route_table.private_app_0.id
  depends_on     = [aws_subnet.private_app_0, aws_route_table.private_app_0]
}

resource "aws_route_table_association" "private_app_1" {
  subnet_id      = aws_subnet.private_app_1.id
  route_table_id = aws_route_table.private_app_1.id
  depends_on     = [aws_subnet.private_app_1, aws_route_table.private_app_1]
}

# PRIVATE SUBNETS DB
resource "aws_subnet" "private_0" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_private_db_0_subnet
  map_public_ip_on_launch = false
  tags = {
    Name         = "private_db_0"
    "Enviroment" = var.enviroment_tag
  }
  depends_on = [aws_vpc.main]

}

resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = false
  cidr_block              = var.cidr_private_db_1_subnet
}

resource "aws_db_subnet_group" "db-subnets" {
  name       = "main"
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
  tags = {
    "Enviroment" = var.enviroment_tag
  }
}

# PRIVATE ROUTE TABLE DB
resource "aws_route_table" "private_db" {
  vpc_id     = aws_vpc.main.id
  depends_on = [aws_vpc.main]
}

resource "aws_route_table_association" "private_db_0" {
  subnet_id      = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_db.id
  depends_on     = [aws_subnet.private_0, aws_subnet.private_1, aws_route_table.private_db]
}

resource "aws_route_table_association" "private_db_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_db.id
  depends_on     = [aws_subnet.private_0, aws_subnet.private_1, aws_route_table.private_db]
}

# SECURITY GROUPS
resource "aws_security_group" "app_instance" {
  name   = "app-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port       = var.port_http
    to_port         = var.port_http
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.nlb.id]
  }
  ingress {
    from_port   = var.port_https
    to_port     = var.port_https
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name         = "public-sub"
    "Enviroment" = var.enviroment_tag
  }
  depends_on = [aws_vpc.main, aws_security_group.nlb]
}

resource "aws_security_group" "db_instance" {
  name   = "db-sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = var.port_db
    to_port     = var.port_db
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name         = "private-sub"
    "Enviroment" = var.enviroment_tag
  }
  depends_on = [aws_vpc.main]
}

# NLB CONFIG
resource "aws_security_group" "nlb" {
  name        = "nlb-sg"
  description = "allow http traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = var.port_https
    to_port     = var.port_https
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.main]

}

