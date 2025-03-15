variable "port_https" {
  description = "Port for HTTPS"
  default     = 443
}
variable "port_http" {
  description = "Port for HTTP"
  default     = 80

}
variable "port_db" {
  description = "Port for DB"
  default     = 3306

}
variable "port_ssh" {
  description = "Port for SSH"
  default     = 22
}
variable "db_user" {
  description = "DB user"
  type        = string
}
variable "db_password" {
  description = "DB password"
  type        = string
}

variable "ami_dev" {
  description = "AMI for dev"
  default     = "ami-08679644760280fae"
}
