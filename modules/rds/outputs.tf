output "host" {
  value = aws_db_instance.mysql.address
}

output "username" {
  value = aws_db_instance.mysql.username
}

output "password" {
  value = aws_db_instance.mysql.password
}