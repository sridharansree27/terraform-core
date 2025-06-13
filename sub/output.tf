output "sub_region" {
  value = "${var.instance_region_sub}-${var.instance_region_sub == data.aws_region.current.region ? "true" : "false"}"
}