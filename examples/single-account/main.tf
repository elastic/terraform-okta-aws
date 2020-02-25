terraform {
  required_version = "~> 0.11.15"
}

provider "aws" {
  version = "2.34.0"
  region  = "us-east-1"
}

module "okta_master_setup" {
  source    = "../../modules/master"
  user_name = "okta-app-user"
}

module "okta_child_setup" {
  source          = "../../modules/child"
  idp_name        = "OktaDemo"
  idp_metadata    = "${file(var.idp_metadata_file)}"
  master_accounts = ["${module.okta_master_setup.okta_master_account_id}"]
}

// create a role that is assumable by Okta
resource "aws_iam_role" "sso_role_tester" {
  name               = "SSOTestRole"
  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    ${module.okta_child_setup.okta_assume_role_stanza}
  ]
}
JSON
}

resource "aws_iam_role_policy" "sso_role_tester_policy" {
  name = "SSOTestRolePolicy"
  role   = "${aws_iam_role.sso_role_tester.name}"
  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:Decribe*"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}