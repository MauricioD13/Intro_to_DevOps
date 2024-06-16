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
    ami           = "ami-0ac67a26390dc374d"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.instance.id]
    user_data = file("../user_data.sh")
    user_data_replace_on_change = true

    tags = {
        Name = "Basic_API"
    }
}

  
resource "aws_iam_policy" "policy" {

	name		="test_policy"
	path		="/"
	description 	= "My test policy"

	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
			Action = [
				"ec2:Describe"
			]
			Effect = "Allow"
			Resource = "*"
		}]
	
	})

}

