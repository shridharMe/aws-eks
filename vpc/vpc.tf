module "vpc" {
 source             = "git::git@github.com:shridharMe/terraform-modules.git//modules/vpc?ref=master"
 name               ="${var.name}"
 cidr               ="${var.cidr}"
 public_subnets     ="${var.public_subnets}"
 private_subnets    ="${var.private_subnets}"
 azs                ="${var.azs}"
 enable_nat_gateway ="${var.enable_nat_gateway}"
 tags {
    "Terraform" = "true"
    "Environment" = "${var.environment}"
  }
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "cidr" {
  value = "${module.vpc.cidr}"
}

output "private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "private_route_tables" {
  value = ["${module.vpc.private_route_tables}"]
}

output "public_route_tables" {
  value = ["${module.vpc.public_route_tables}"]
}

output "internet_gateway" {
  value = "${module.vpc.internet_gateway}"
}