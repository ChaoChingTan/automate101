provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "lnxsr" {
  ami           = var.lnxsr_ami
  instance_type = var.lnxsr_instance_type
  vpc_security_group_ids = [ aws_security_group.ssh-sg.id ]
  key_name = var.lnxsr_key_name
  count = var.server_count

  tags = {
    Name = "lnxsr-${count.index}"
  }
}

resource "aws_security_group" "ssh-sg" {
  name = "ssh-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "all_public_ips" {
  value       = aws_instance.lnxsr[*].public_ip
  description = "Public IPs of all lnxsr instances"
}
