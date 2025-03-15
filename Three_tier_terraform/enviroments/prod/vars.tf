variable "base_cidr_block" {
  description = "Base IP addresses"
  default     = "10.0.0.0/16"
}
variable "cidr_public_subnet_0" {
  description = "IP address block public subnet"
  default     = "10.0.0.0/24"
}
variable "cidr_public_subnet_1" {
  description = "IP address block public subnet"
  default     = "10.0.1.0/24"
}
variable "cidr_private_app_0_subnet" {
  description = "IP address block private subnet"
  default     = "10.0.2.0/24"
}
variable "cidr_private_app_1_subnet" {
  description = "IP address block private subnet"
  default     = "10.0.3.0/24"
}
variable "cidr_private_db_0_subnet" {
  description = "IP address block private subnet"
  default     = "10.0.10.0/24"
}
variable "cidr_private_db_1_subnet" {
  description = "IP address block private subnet"
  default     = "10.0.11.0/24"
}
variable "port_http" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "port_https" {
  description = "The port the server will use for HTTPS requests"
  type        = number
  default     = 443
}

variable "port_ssh" {
  description = "SSH port"
  type        = number
  default     = 22

}
variable "port_db" {
  description = "MySQL port"
  type        = number
  default     = 3306
}

variable "enviroment_tag" {
  description = "Enviroment tag"
  default     = "production"
}

variable "ubuntu_ami_id" {
  description = "value"
  type        = string
  default     = "ami-0776c814353b4814d"
}

variable "app_ami_id" {
  description = "value"
  type        = string
  default     = "ami-0776c814353b4814d"
}
variable "db_user" {
  type = string
}
variable "db_password" {
  type = string
}
