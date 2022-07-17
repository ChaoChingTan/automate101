provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "webserver" {
  ami           = var.lnxsr_ami
  instance_type = var.lnxsr_instance_type
  vpc_security_group_ids = [ aws_security_group.webserver-sg.id, aws_security_group.ssh-sg.id, aws_security_group.outbound-sg.id ]
  key_name = var.lnxsr_key_name

  user_data = <<-EOF
              #!/bin/bash

              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd

              echo "Hello, World" > /var/www/html/index.html
              EOF

# since user data only runs on first boot
  user_data_replace_on_change = true

  tags = {
    Name = "webserver-03"
  }
}

resource "aws_security_group" "webserver-sg" {
  name = "webserver-sg"

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
}

resource "aws_security_group" "outbound-sg" {
  name = "outboung-sg"

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}