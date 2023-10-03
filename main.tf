
terraform {
  required_version = ">= 1.3.7, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.7"
    }
  }

}

provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  #version = "~> 2.7"
}

resource "aws_instance" "MyEc1" {
  ami           = "ami-03a6eaae9938c858c"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.SecGroupe.id]
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  
  tags = {
    Name = "MyEc1"
  }
  
}

resource "aws_security_group" "SecGroupe" {

  #name = var.security_group_name

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

#variable "security_group_name" {
#  description = "The name of the security group"
#  type        = string
#  default     = "terraform-example-instance"
#}

output "public_ip" {
  value       = aws_instance.MyEc1.public_ip
  description = "The public IP of the Instance"
}