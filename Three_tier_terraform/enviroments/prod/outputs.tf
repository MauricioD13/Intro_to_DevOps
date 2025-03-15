output "public_dns" {
  value = aws_lb.public-nlb.dns_name
}

output "public_ip" {
  value = aws_lb.public-nlb.ip_address_type
}
