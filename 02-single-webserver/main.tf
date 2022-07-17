provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  #security_groups = [aws_security_group.webserver-sg.id,aws_security_group.ssh-sg.id]
  vpc_security_group_ids = [ aws_security_group.webserver-sg.id, aws_security_group.ssh-sg.id, aws_security_group.outbound-sg.id ]
  key_name = "vockey"

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
    Name = "webserver-02"
  }
}

resource "aws_security_group" "webserver-sg" {
  name = "webserver-sg"

  ingress {
    from_port   = 80
    to_port     = 80
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