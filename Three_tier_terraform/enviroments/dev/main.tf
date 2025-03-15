data "aws_ami" "dev-from-prod" {
  most_recent = true
  owners      = ["self"]
  tags = {
    Name        = "v17-dev"
    environment = "dev"
  }
}

resource "aws_instance" "dev-main" {
  ami             = var.ami_dev
  instance_type   = "t3.small"
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.public.id]
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price                      = "0.0110"
      instance_interruption_behavior = "terminate"
      spot_instance_type             = "one-time"
    }
  }

  tags = {
    Name        = "dev-spot"
    environment = "dev"
  }
  depends_on = [aws_subnet.public, aws_security_group.public]
}


resource "aws_security_group" "public" {
  vpc_id = aws_vpc.main-dev.id
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
  ingress {
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.main-dev]
  tags = {
    Name        = "public"
    environment = "dev"
  }
}

