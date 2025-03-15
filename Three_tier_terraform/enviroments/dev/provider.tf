terraform {
  backend "s3" {
    bucket  = "tfstate-dev-aparcacoches"
    key     = "state/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "aparcacoches-dev"
}
