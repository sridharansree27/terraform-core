variable "reference_resource" {
  description = "CIDR block for the VPC"
  type        = list(string)
}

check "health_check" {
  /*
  data "http" "terraform_io" {
    url = "https://www.terraform.io"
  }
  
  assert {
    condition = data.http.terraform_io.status_code == 200
    error_message = "${data.http.terraform_io.url} returned an unhealthy status code"
  }
  */

  data "aws_instances" "server" {
    filter {
      # name   = "tag:Name"
      # values = ["server"]
      name   = "tag:region"
      values = ["${var.instance_region_root}"]
    }
    depends_on = [var.reference_resource] #[ aws_instance.server ]
  }
  assert {
    condition     = length(data.aws_instances.server.ids) > 0
    error_message = "No EC2 instances found with tag region=${var.instance_region_root}"
  }
}