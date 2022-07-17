variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "http_port" {
  description = "Port of HTTP server"
  type        = number
  default     = 80
}
