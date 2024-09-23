terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_instance" "app_server" {
  ami                         = "ami-0ac67a26390dc374d"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.api.id]
  user_data                   = file("./additional_code/user_data.sh")
  user_data_replace_on_change = true
  subnet_id                   = aws_subnet.public.id
  monitoring                  = true
  iam_instance_profile = aws_iam_instance_profile.ec2_dynamodb_profile.name
  associate_public_ip_address = true
  tags = {
    Name = "BasicAPI"
  }
}

resource "aws_dynamodb_table" "recipes_table" {
  name           = "recipes_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "RecipeId"
  attribute {
    name = "RecipeId"
    type = "S"
  }
  tags = {
    Name = "BasicAPI"
  }
}
