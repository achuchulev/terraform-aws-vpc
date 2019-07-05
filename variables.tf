variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "VPC cidr block"
}

variable "vpc_subnet_cidr_blocks" {
  type        = "list"
  default     = ["10.0.0.0/16"]
  description = "VPC subnet cidr blocks"
}

variable "vpc_tags" {
  type        = "map"
  description = "VPC tag"

  default = {
    Name = ""
  }
}

variable "ssh_port" {
  default = 22
}

variable "ssh_cidr" {
  default = "0.0.0.0/0"
}

variable "icmp_cidr" {
  default = "0.0.0.0/0"
}
