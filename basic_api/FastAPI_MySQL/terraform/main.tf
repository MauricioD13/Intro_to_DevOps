data "aws_ami" "main" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.main.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  root_block_device {
    volume_type = "gp3"
    volume_size = 20
  }
  key_name = "tf_key"
  tags = {
    Name = "RecipeApp"
  }
}
