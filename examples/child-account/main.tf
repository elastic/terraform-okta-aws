terraform {
  required_version = "~> 0.11.15"
}

provider "aws" {
  version = "2.34.0"
  region  = "us-east-1"
}

module "okta_child_setup" {
  source                 = "../../modules/child"
  idp_name               = "DemoOkta"
  idp_metadata           = "${file(var.idp_metadata_file)}"
  master_accounts        = ["${var.master_account_ids}"]
  add_cross_account_role = false
}

// create a role that is assumable by Okta
resource "aws_iam_role" "sso_role_ec2" {
  name               = "EC2ReadOnly"
  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    ${module.okta_child_setup.okta_assume_role_statement}
  ]
}
JSON
}

resource "aws_iam_role_policy" "sso_role_ec2_policy" {
  name   = "EC2ReadOnlyPolicy"
  role   = "${aws_iam_role.sso_role_ec2.name}"
  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}

// create another role that is assumable by Okta
resource "aws_iam_role" "sso_role_admin" {
  name               = "Admin"
  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    ${module.okta_child_setup.okta_assume_role_statement}
  ]
}
JSON
}
resource "aws_iam_role_policy" "sso_role_admin_policy" {
  name   = "AdminPolicy"
  role   = "${aws_iam_role.sso_role_admin.name}"
  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "NotAction": [
        "organizations:*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "organizations:DescribeOrganization"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}