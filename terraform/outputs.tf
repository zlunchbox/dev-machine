output "instance_public_ip" {
  description = "Public IP of the dev machine"
  value       = aws_instance.dev_machine.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the dev machine"
  value       = "ssh -i ~/.ssh/dev-machine-key ubuntu@${aws_instance.dev_machine.public_ip}"
}
