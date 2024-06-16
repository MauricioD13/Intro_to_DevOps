resource "aws_vpc" "main"  {
    cidr_block = var.base_cidr_block
  
  }
resource "aws_security_group" "instance" {
      name = "api-sg"
      ingress {
          from_port = var.server_port
          to_port = var.server_port
          protocol = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "public-sub"
    }
}
