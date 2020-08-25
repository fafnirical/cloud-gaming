output "instance_ip" {
  value       = aws_instance.gaming.public_ip
  description = "The public IP address of the instance. Use this for RDP."
}

output "windows_password" {
  value       = rsadecrypt(aws_instance.gaming.password_data, file("gaming.pem"))
  description = "The administrator password of the instance. Use this for RDP."
}
