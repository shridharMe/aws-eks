data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "myco-terraform-state"
    key    = "vpc/us-east-1.tfstate"
    region = "us-east-1"
  }
}
