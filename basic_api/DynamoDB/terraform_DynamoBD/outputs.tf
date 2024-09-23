output "public_dns" {
  value = aws_instance.app_server.public_dns
}

output "table_name" {
  value = aws_dynamodb_table.recipes_table.name
}
data "aws_caller_identity" "current" {}
output "caller" {
  value = data.aws_caller_identity.current
}