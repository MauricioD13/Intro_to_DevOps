variable "aws_region" {
  default = "eu-west-1"
}

variable "db_username" {
  type = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "YourStrongPassword123!"
}
