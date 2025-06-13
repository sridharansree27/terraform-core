variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "cidr" {
  type = list(string)
}

variable "ingress_rules" {
  type = list(object({
    name        = string
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      name        = "HTTP"
      description = "HTTP from VPC"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      name        = "SSH"
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "variable_resource" {
  type    = string
  default = " "
}

variable "instance_region_root" {
  type    = string
  default = ""
}

variable "instance_region_sub" {
  type    = string
  default = ""
}