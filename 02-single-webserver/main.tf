provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum install httpd -y
              systemctl start httpd
              echo "Hello, World" > /var/www/html/index.html
              EOF

# since user data only runs on first boot
  user_data_replace_on_change = true

  tags = {
    Name = "webserver-01"
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