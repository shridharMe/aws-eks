data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "env:/dev-devops/vpc/us-east-1.tfstate"
    region = "us-east-1"
  }
}

module "workstation-external" {
    source  ="git::https://github.com/shridharMe/terraform-modules.git//modules/workstation?ref=master"
}

module "eks-cluster" {
 source                     = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-cluster?ref=master"
 vpc_id                     = "${data.terraform_remote_state.vpc.vpc_id}"
 public_subnets             = "${element(data.terraform_remote_state.vpc.public_subnets, 0)}"
 private_subnets-cidr        ="10.1.4.0/24"
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

