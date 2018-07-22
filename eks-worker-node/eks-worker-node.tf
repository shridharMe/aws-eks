module "eks-cluster" {
 source                 = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-worker-node?ref=master"
 vpc_id                 = "${data.terraform_remote_state.vpc.vpc_id}"
 public_subnet          = "${data.terraform_remote_state.vpc.public_subnets}"
 private_subnet         = "${data.terraform_remote_state.vpc.public_subnets}"
 cluster-name           = "${data.terraform_remote_state.eks-cluster.cluster-name}"
 cluster-endpoint       = "${data.terraform_remote_state.eks-cluster.cluster-endpoint}"
 cluster-security-id    = "${data.terraform_remote_state.eks-cluster.cluster-security-id}"
 node-instance-type     = "${var.node-instance-type}"
 desired-capacity       = "${var.desired-capacity}"
 max-size               = "${var.max-size}"
 min-size               = "${var.min-size}"
}


output "node-security-id" {
  value = "${module.eks-cluster.node-security-id}"
}