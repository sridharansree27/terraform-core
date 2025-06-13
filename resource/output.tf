output "cidr" {
  value = var.cidr
}

output "instance" {
  value = aws_instance.server
}

output "sub_region" {
  value = [module.vpc_remote[*].sub_region]
}