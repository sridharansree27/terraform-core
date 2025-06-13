terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "6.0.0-beta2", configuration_aliases = [aws.usa] }
  }
}

resource "aws_key_pair" "key" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

moved {
  from = aws_key_pair.example
  to   = aws_key_pair.key
}

resource "aws_vpc" "vpc" {
  for_each   = { for idx, cidr in var.cidr : tostring(idx) => cidr }
  cidr_block = each.value
}

resource "aws_subnet" "sub" {
  for_each                = aws_vpc.vpc
  vpc_id                  = each.value.id
  cidr_block              = local.cidr_map[each.key]
  availability_zone       = "${var.instance_region_root}a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  for_each = aws_vpc.vpc
  vpc_id   = each.value.id
}

resource "aws_route_table" "RT" {
  for_each = aws_vpc.vpc
  vpc_id   = each.value.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[each.key].id
  }
}

resource "aws_route_table_association" "rta1" {
  for_each       = aws_subnet.sub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.RT[each.key].id
}

resource "aws_security_group" "webSg" {
  name     = "web"
  for_each = aws_vpc.vpc
  vpc_id   = each.value.id

  /* # dynamic block replaced the following repetative block
  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
*/

  dynamic "ingress" {
    for_each = var.ingress_rules
    iterator = loop_var # if iterator attribute is omitted loop variable name is same as dynamic block name(ie, ingress)
    content {
      description = loop_var.value.description
      from_port   = loop_var.value.from_port
      to_port     = loop_var.value.to_port
      protocol    = loop_var.value.protocol
      cidr_blocks = loop_var.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

resource "terraform_data" "variable_resource" {
  input            = var.variable_resource
  triggers_replace = var.variable_resource
}

resource "aws_instance" "server" {
  for_each               = aws_subnet.sub
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.webSg[each.key].id]
  subnet_id              = each.value.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "app.java"
    destination = "/home/ubuntu/app.java"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y openjdk-11-jdk",
      "cd /home/ubuntu",
      "javac app.java",
      "java app"
    ]
  }

  depends_on = [
    aws_key_pair.key,
    aws_vpc.vpc
  ]

  tags = {
    Name   = "server-${each.key}"
    region = "${var.instance_region_root}"
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes = [
      tags
    ]
    replace_triggered_by = [terraform_data.variable_resource]
  }
}

data "aws_instance" "server" {
  for_each    = aws_instance.server
  instance_id = each.value.id
  lifecycle {
    precondition {
      condition     = each.value.availability_zone != null
      error_message = "Instance must have a valid availability zone."
    }
    postcondition {
      condition     = lookup(self.tags, "region", "") == "${var.instance_region_root}"
      error_message = "Tag [region] must be set to ${var.instance_region_root}"
    }
  }
}

module "vpc_remote" {
  source = "../sub"
  providers = {
    aws.usa = aws.usa
  }
  cidr                = var.cidr[count.index]
  count               = length(var.cidr)
  instance_region_sub = var.instance_region_sub
}