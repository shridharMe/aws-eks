module "workstation-external" {
    source  ="git::git@github.com:shridharMe/terraform-modules.git//modules/workstation?ref=master"
}

module "eks-cluster" {
 source                     = "git::git@github.com:shridharMe/terraform-modules.git//modules/eks-cluster?ref=master"
 vpc_id                     = "${data.terraform_remote_state.vpc.vpc_id}"
 public_subnet              = "${data.terraform_remote_state.vpc.public_subnets}"
 private_subnet             = "${data.terraform_remote_state.vpc.public_subnets}"
 cluster-name               = "${var.cluster-name}" 
 workstation-external-cidr  = "${module.workstation-external.workstation-external-cidr}"
}


