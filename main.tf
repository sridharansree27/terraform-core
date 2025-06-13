terraform {
  required_version = ">=1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0-beta2"
    }
  }
}

/*
# HCP Terraform-> manually login using email id and password

  cloud {     
    organization = "sridharan27" 
    token = "" # provide token
    workspaces { 
     # name = "sridharan27" 
     # tags = [ "dev" ]
      tags = {
         env = "dev"
       }
    } 
  }
*/
/* 
  backend "remote" {     
    organization = "sridharan27" 
    token = "" # provide token
    workspaces { 
      name = "sridharan27" 
    } 
  }
*/

/*
  backend "local" {
    path = "state/terraform.tfstate"
  }
*/


# provider configuration
provider "aws" {
  region     = var.instance_region_root
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "aws" {
  alias      = "usa"
  region     = var.instance_region_sub
  access_key = var.access_key
  secret_key = var.secret_key
}

module "expression" {
  source = "./expression"
}

module "check" {
  source               = "./expression/check"
  reference_resource   = [for k, v in module.resource.instance : v.id]
  instance_region_root = var.instance_region_root

}

module "resource" {
  source = "./resource"
  providers = {
    aws     = aws
    aws.usa = aws.usa
  }
  cidr                 = var.cidr
  ami                  = var.ami
  instance_type        = var.instance_type
  instance_region_root = var.instance_region_root
  instance_region_sub  = var.instance_region_sub
}