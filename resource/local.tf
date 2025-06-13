locals {
  # Create a map like { "0" = "10.0.0.0/16", "1" = "10.1.0.0/16", ... }
  cidr_map = { for k, v in aws_vpc.vpc : k => v.cidr_block }
}