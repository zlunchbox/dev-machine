variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 20
}

variable "public_key_path" {
  description = "Path to the SSH public key to register with AWS"
  type        = string
  default     = "~/.ssh/dev-machine-key.pub"
}
