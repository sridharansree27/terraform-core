variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "cidr" {
  type      = list(string)
  default   = []
  nullable  = false
  ephemeral = false
  sensitive = false
}

variable "ami" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "instance_region_root" {
  type    = string
  default = ""
}

variable "instance_region_sub" {
  type    = string
  default = ""
}