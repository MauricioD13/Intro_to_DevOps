variable "base_cidr_block"{
    description = "Base IP addresses"
    default = "10.0.0.0/16"
}

variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 8080
}