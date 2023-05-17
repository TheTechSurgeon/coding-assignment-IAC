terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "local_file" "python_program" {
  filename = var.python_program_path
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

resource "aws_iam_role" "role" {
  name = "${var.bucket_name}-role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "policy" {
  name = "${var.bucket_name}-policy"
  role = aws_iam_role.role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": ["s3:ListBucket"],
        "Effect": "Allow",
        "Resource": ["${aws_s3_bucket.bucket.arn}"]
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.bucket_name}-profile"
  role = aws_iam_role.role.name
}


resource "aws_instance" "test" {
  ami                    = ami-06a0cd9728546d178
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]

  iam_instance_profile = aws_iam_instance_profile.profile.name


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