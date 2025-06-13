variable "instance_region_sub" {
  type    = string
  default = ""
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}