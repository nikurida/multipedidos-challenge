output "table_arn" {
  value = aws_dynamodb_table.crud_table.arn
}

output "table_name" {
  value = aws_dynamodb_table.crud_table.name
}
