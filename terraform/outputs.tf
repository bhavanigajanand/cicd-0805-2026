output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.cicd_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.cicd_server.public_dns
}

output "jenkins_url" {
  description = "Jenkins UI URL"
  value       = "http://${aws_instance.cicd_server.public_ip}:8080"
}

output "app_url" {
  description = "Flask app URL"
  value       = "http://${aws_instance.cicd_server.public_ip}:5000"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.cicd_server.public_ip}"
}

output "key_pair_file" {
  description = "Path to the generated private key"
  value       = "${path.module}/${var.key_name}.pem"
}
