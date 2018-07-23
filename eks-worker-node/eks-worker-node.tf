data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "env:/dev-devops/vpc/us-east-1.tfstate"
    region = "us-east-1"
  }
}


data "terraform_remote_state" "eks-cluster" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "env:/dev-devops/eks-cluster/us-east-1.tfstate"
    region = "us-east-1"
  }
}

module "eks-worker-node" {
 source                 = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-worker-node?ref=master"
 vpc_id                 = "${data.terraform_remote_state.vpc.vpc_id}"
 public_subnet_cidr      = "10.1.1.0/24,10.1.2.0/24"
 private_subnet         = "${element(data.terraform_remote_state.vpc.private_subnets, 0)},${element(data.terraform_remote_state.vpc.private_subnets, 1)}"
 cluster-name           = "${data.terraform_remote_state.eks-cluster.cluster-name}"
 cluster-endpoint       = "${data.terraform_remote_state.eks-cluster.cluster-endpoint}"
 cluster-security-id    = "${data.terraform_remote_state.eks-cluster.cluster-security-id}"
 node-instance-type     = "${var.node-instance-type}"
 desired-capacity       = "${var.desired-capacity}"
 max-size               = "${var.max-size}"
 min-size               = "${var.min-size}"
}


output "node-security-id" {
  value = "${module.eks-worker-node.node-security-id}"
}
output "node-role-arn" {
  value = "${module.eks-worker-node.node-role-arn}"
}