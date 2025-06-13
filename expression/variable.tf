variable "image_id" {
  type = string
  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
  default = "ami-123"
}

variable "name" {
  type    = string
  default = "Terraform"
}

variable "map" {
  type = map(string)
  default = {
    "Alice"   = "admin"
    "Bob"     = "admin"
    "Charlie" = "dev"
  }
}

variable "list_name" {
  type    = list(string)
  default = ["Alice", "Bob", "Charlie"]
}

variable "users" {
  type = map(object({
    is_admin = bool
  }))

  default = {
    "alice" = {
      is_admin = true
    },
    "bob" = {
      is_admin = false
    }
  }
}

variable "grouping" {
  type = list(object({
    role = string
    name = string
  }))
  default = [
    { role = "admin", name = "Alice" },
    { role = "admin", name = "Bob" },
    { role = "dev", name = "Charlie" }
  ]
}

variable "splat_null_test_1" {
  type = list(object({
    args1 = object({
      null_test = bool
    })
  }))
  default = [{ args1 = {
    null_test = true
    } }, { args1 = {
    null_test = false
  } }]
}

variable "splat_null_test_2" {
  type = object({
    index_document = string
    error_document = string
  })
  # default = null
  default = {
    index_document = "index.tf"
    error_document = "error.tf"
  }
}

variable "dynamic_nested" {
  type = map(object({
    origins = set(object({
      hostname = string
    }))
  }))
  default = {
    group1 = {
      origins = [
        { hostname = "origin1.example.com" },
        { hostname = "origin2.example.com" }
      ]
    },
    group2 = {
      origins = [
        { hostname = "origin3.example.com" }
      ]
    }
  }
}