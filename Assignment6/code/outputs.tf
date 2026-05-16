output "public_ip" {
  value = aws_instance.web_server.public_ip
}

output "private_ip" {
  value = aws_instance.web_server.private_ip
}

output "db_private_ip" {
  value = aws_instance.db_server.private_ip
}

output "IAM_User" {
  value = aws_iam_user.user.name
}