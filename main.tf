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

resource "aws_instance" "test"{
    ami = ami-06a0cd9728546d178
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    key_name = var.key_name
    vpc_security_group_ids = [var.security_group_id]
} 