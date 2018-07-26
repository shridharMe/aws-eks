

module "vpc" {
 source             = "git::https://github.com/shridharMe/terraform-modules.git//modules/vpc?ref=master"
 name               ="${var.name}"
 cidr               ="${var.cidr}"
 public_subnets     ="${var.public_subnets}"
 private_subnets    ="${var.private_subnets}"
 azs                ="${var.azs}"
 owner              ="${var.owner}"
 environment        ="${var.environment}"
 terraform          ="${var.terraform}"

}
module "workstation-external" {
    source  ="git::https://github.com/shridharMe/terraform-modules.git//modules/workstation?ref=master"
}

module "eks-cluster" {
 source                     = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-cluster?ref=master"
 vpc_id                     = "${module.vpc.vpc_id}"
 public_subnets             = "${module.vpc.public_subnets}"
 private_subnets_cidr       ="${module.vpc.private_subnets_cidr}"
 cluster-name               = "${var.cluster-name}" 
 workstation-external-cidr  = "${module.workstation-external.workstation-external-cidr}"
}

module "eks-worker-node" {
 source                     = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-worker-node?ref=master"
 vpc_id                     = "${module.vpc.vpc.vpc_id}"
 cluster-name               = "${module.eks-cluster.cluster-name}"
 cluster-endpoint           = "${module.eks-cluster.cluster-endpoint}"
 cluster-certificate-data   = "${module.eks-cluster.cluster-certificate-data}"
 node-instance-type         = "${var.node-instance-type}"
 desired-capacity           = "${var.desired-capacity}"
 max-size                   = "${var.max-size}"
 min-size                   = "${var.min-size}"
 public_subnet_cidr         = "${module.vpc.public_subnets_cidr}"
 private_subnet             = "${module.vpc.private_subnets}"
}

module "kube-config" {
    source                            = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-kube-config?ref=master"
    role_node_arn                     = "${module.eks-worker-node.role_node_arn}"
    cluster_eks_endpoint              = "${module.eks-cluster.cluster_eks_endpoint}"
    cluster_eks_certificate_authority = "${module.eks-cluster.cluster-certificate-data}"
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
output "node-security-id" {
  value = "${module.eks-worker-node.node-security-id}"
}
output "node-role-arn" {
  value = "${module.eks-worker-node.node-role-arn}"
}
output "config-map-aws-auth" {
  value = "${module.config-map-aws-auth}"
}

output "kubeconfig" {
  value = "${module.kubeconfig}"
}