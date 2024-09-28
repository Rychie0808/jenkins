output "maven-ip" {
    value = aws_instance.maven.public_ip

}

output "jenkins-ip" {
  value = aws_instance.jenkins.public_ip
}

output "prod-ip" {
  value = aws_instance.prod.public_ip
}
