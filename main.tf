# Create VPC resource
resource "aws_vpc" "new_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = "${var.vpc_tags}"
}

# Create subnets for VPC
resource "aws_subnet" "vpc_subnet" {
  count                   = "${length(var.vpc_subnet_cidr_blocks)}"
  vpc_id                  = "${aws_vpc.new_vpc.id}"
  map_public_ip_on_launch = true
  cidr_block              = "${var.vpc_subnet_cidr_blocks[count.index]}"
}

# Create Internet GW for VPC resource
resource "aws_internet_gateway" "vpc_internet_gw" {
  vpc_id = "${aws_vpc.new_vpc.id}"

  tags {
    Name = "Internet Gateway for VPC"
  }
}

# Create route for VPC internet access
resource "aws_route" "internet_access_vpc_route" {
  route_table_id         = "${aws_vpc.new_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.vpc_internet_gw.id}"
}

# Assosiate main route tables with subnets
resource "aws_route_table_association" "vpc_subnet_route_assoc" {
  count          = "${length(var.vpc_subnet_cidr_blocks)}"
  subnet_id      = "${aws_subnet.vpc_subnet.*.id[count.index]}"
  route_table_id = "${aws_vpc.new_vpc.main_route_table_id}"
}

# Create security group for VPC that allows ssh and icmp echo request/reply inbound traffic 
resource "aws_security_group" "vpc_ssh_icmp_echo_sg" {
  name        = "ssh_icmp_echo_enabled_sg"
  description = "Allow traffic needed for ssh and icmp echo request/reply"
  vpc_id      = "${aws_vpc.new_vpc.id}"

  // Custom ICMP Rule - IPv4 Echo Reply
  ingress {
    from_port   = "0"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["${var.icmp_cidr}"]
  }

  // Custom ICMP Rule - IPv4 Echo Request
  ingress {
    from_port   = "8"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["${var.icmp_cidr}"]
  }

  // ssh
  ingress {
    from_port   = "${var.ssh_port}"
    to_port     = "${var.ssh_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_cidr}"]
  }

  // all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${aws_vpc.new_vpc.tags.Name}"
  }
}
