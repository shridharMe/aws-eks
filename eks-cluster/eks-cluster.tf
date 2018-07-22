module "workstation-external" {
    source  ="git::https://github.com/shridharMe/terraform-modules.git//modules/workstation?ref=master"
}

module "eks-cluster" {
 source                     = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-cluster?ref=master"
 vpc_id                     = "${data.terraform_remote_state.vpc.vpc_id}"
 public_subnet              = "${data.terraform_remote_state.vpc.public_subnets}"
 private_subnet             = "${data.terraform_remote_state.vpc.public_subnets}"
 cluster-name               = "${var.cluster-name}" 
 workstation-external-cidr  = "${module.workstation-external.workstation-external-cidr}"
}



output "cluster-endpoint" {
  value = "${module.eks-cluster.cluster-endpoint}"
}
output "cluster-security-id" {
  value = "${module.eks-cluster.cluster-security-id}"
}

output "cluster-name" {
  value = "${module.eks-cluster.cluster-name}"
}

output "cluster-certificate-data" {
  value = "${module.eks-cluster.cluster-certificate-data}"
}

output "cluster-arn" {
  value = "${module.eks-cluster.cluster-arn}"
}


output "workstation-external-cidr" {
  value = "${module.workstation-external.workstation-external-cidr}"
}

output "kubeconfig" {
  value = "${module.eks-cluste.kubeconfig}"
}

output "config-map" {
  value = "${module.eks-cluste.config-map-aws-auth}"
}