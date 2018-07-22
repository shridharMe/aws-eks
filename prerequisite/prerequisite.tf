module "prerequisite" {
    source              = "git::https://github.com/shridharMe/terraform-modules.git//modules/prerequisite?ref=master"
    dynamodb_table      = "${var.dynamodb_table}"
    s3_region           = "${var.s3_region }"
    s3_bucket_name      = "${var.s3_bucket_name}"
    env                 = "${var.dev}"
    terraform_user_arn  = "${var.terraform_user_arn}"
}