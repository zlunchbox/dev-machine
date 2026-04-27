output "instance_public_ip" {
  description = "Public IP of the dev machine"
  value       = aws_instance.dev_machine.public_ip
}

output "instance_id" {
  description = "Instance ID of the dev machine"
  value       = aws_instance.dev_machine.id
}

output "aws_region" {
  description = "AWS region the dev machine is deployed in"
  value       = var.aws_region
}

output "ssh_command" {
  description = "SSH command to connect to the dev machine"
  value       = "ssh -A -i ~/.ssh/dev-machine-key ubuntu@${aws_instance.dev_machine.public_ip}"
}
