

output "pub_IP" {
  description = "VPC ID"
  value       = aws_eip.task.public_ip
}



