variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
  default     = "ami-0e2420433e60829b5"
}
resource "aws_instance" "main" {
  ami                         = var.ami
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
  depends_on = [aws_vpc.main, aws_subnet.public]
}
