output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "jenkins_url" {
  value = "http://${aws_instance.jenkins.public_ip}:8080"
}

output "k3s_public_ip" {
  description = "k3s public ip"
  value       = aws_instance.k3s.public_ip
}