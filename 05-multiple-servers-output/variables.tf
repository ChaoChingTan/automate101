variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "server_count" {
  description = "Number of servers"
  type        = number
  default     = 2
}

variable "http_port" {
  description = "Port of HTTP server"
  type        = number
  default     = 80
}

variable "lnxsr_ami" {
  description = "Linux Server AMI to use"
  type        = string
  default     = "ami-0cff7528ff583bf9a"
}

variable "lnxsr_instance_type" {
  description = "Instance type of server to deploy"
  type = string
  default = "t2.micro"
}

variable "lnxsr_key_name" {
  description = "Instance key pair"
  type = string
  default = "vockey"
}