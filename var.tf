variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "volume_size" {
  description = "EBS volume size"
  type        = number
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-west-2"
}

variable "subnet_id" {
  description = "The subnet ID where instance will be launched"
  type        = string
}

variable "keypair_name" {
  description = "The name of the keypair"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the Security Group"
  type        = string
}

variable "python_program_path" {
  description = "The path to the Python program to be uploaded"
  type        = string
  default     = "./scripts/program.py"
}

