module "eks" {
  source             = "git::https://github.com/shridharMe/terraform-modules.git//modules/eks?ref=master"
  name                = "${var.name}"
  cidr               = "${var.cidr}"
  public_subnets     = "${var.public_subnets}"
  private_subnets    = "${var.private_subnets}"
  azs                = "${var.azs}"
  owner              = "${var.owner}"
  environment        = "${var.environment}"
  terraform          = "${var.terraform}"
  node-instance-type = "${var.node-instance-type}"
  desired-capacity   = "${var.desired-capacity}"
  max-size           = "${var.max-size}"
  min-size           = "${var.min-size}"
}

output "cluster-endpoint" {
  value = "${module.eks.cluster-endpoint}"
}

output "cluster-security-id" {
  value = "${module.eks.cluster-security-id}"
}

output "cluster-name" {
  value = "${module.eks.cluster-name}"
}

output "cluster-certificate-data" {
  value = "${module.eks.cluster-certificate-data}"
}

output "cluster-arn" {
  value = "${module.eks.cluster-arn}"
}

output "workstation-external-cidr" {
  value = "${module.eks.workstation-external-cidr}"
}

output "node-security-id" {
  value = "${module.eks.node-security-id}"
}

output "node-role-arn" {
  value = "${module.eks.node-role-arn}"
}

output "config-map-aws-auth" {
  value = "${module.eks.config-map-aws-auth}"
}

output "kubeconfig" {
  value = "${module.eks.kubeconfig}"
}
