output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "kinds_public_ip" {
  description = "kinds public ip"
  value       = aws_instance.kinds.public_ip
}