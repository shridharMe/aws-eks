data "terraform_remote_state" "cluster" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "eks-cluster/us-east-1.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "node" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "eks-worker-node/us-east-1.tfstate"
    region = "us-east-1"
  }
}

module "kube-config" {
    source                 = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks-kube-config?ref=master"
    role_node_arn          = "${data.terraform_remote_state.node.role_node_arn}"
    cluster_eks_endpoint   = "${data.terraform_remote_state.cluster.cluster_eks_endpoint}"
    cluster_eks_certificate_authority = "${data.terraform_remote_state.cluster.cluster-certificate-data}"
}

output "config-map-aws-auth" {
  value = "${module.config-map-aws-auth}"
}

output "kubeconfig" {
  value = "${module.kubeconfig}"
}