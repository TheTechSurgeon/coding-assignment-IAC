terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}

data "local_file" "python_program" {
  filename = var.python_program_path
}

resource "aws_instance" "test"{
    ami = ami-06a0cd9728546d178
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name = var.key_name
    vpc_security_group_ids = [var.security_group_id]

      ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = var.volume_size
  }
  user_data = <<-EOF
              #!/bin/bash
              echo '${data.local_file.python_program.content}' > /home/ec2-user/program.py
              python3 /home/ec2-user/program.py
              EOF

  tags = {
    Name = "example-instance"
  }

} 