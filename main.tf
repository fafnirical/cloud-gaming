terraform {
  required_version = ">= 0.12"

  required_providers {
    aws  = "~> 3.3.0"
    http = "~> 1.2.0"
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_vpc" "gaming" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Gaming"
  }
}

resource "aws_subnet" "gaming" {
  vpc_id                  = aws_vpc.gaming.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Gaming"
  }
}

resource "aws_security_group" "gaming" {
  name   = "gaming"
  vpc_id = aws_vpc.gaming.id

  tags = {
    Name = "Gaming"
  }
}

resource "aws_security_group_rule" "ingress_rdp" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [format("%s/%s", local.my_public_ip, 32)]
  security_group_id = aws_security_group.gaming.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.gaming.id
}

resource "aws_key_pair" "gaming" {
  key_name   = "gaming"
  public_key = file("gaming.pub")

  tags = {
    Name = "Gaming"
  }
}

resource "aws_instance" "gaming" {
  ami                    = var.amis[var.region]
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.gaming.id]
  subnet_id              = aws_subnet.gaming.id
  get_password_data      = true

  tags = {
    Name = "Gaming"
  }
}
