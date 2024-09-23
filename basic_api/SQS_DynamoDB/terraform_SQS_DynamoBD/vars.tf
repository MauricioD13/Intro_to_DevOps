variable "base_cidr_block" {
  description = "Base IP addresses"
  default     = "10.0.0.0/16"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 5000
}
variable "ssh_port" {
  description = "SSH port"
  type        = number
  default     = 22
}
variable "sql_port" {
  description = "SQL port"
  type        = number
  default     = 3306

}

variable "environment" {
  description = "Enviroment"
  type        = string
  default     = "production"
}