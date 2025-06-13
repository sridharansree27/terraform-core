terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "6.0.0-beta2", configuration_aliases = [aws.usa] }
  }
}

resource "aws_vpc" "vpc_remote" {
  provider   = aws.usa
  cidr_block = var.cidr
  tags = {
    Name = "MyVPC-USA"
  }
}

data "aws_region" "current" {
  provider = aws.usa
}