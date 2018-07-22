data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "vpc/eu-west-1.tfstate"
    region = "eu-west-1"
  }
}


data "terraform_remote_state" "eks-cluster" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "eks-cluster/eu-west-1.tfstate"
    region = "eu-west-1"
  }
}