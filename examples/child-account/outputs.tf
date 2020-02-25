output "okta_idp_arn" {
  value = "${module.okta_child_setup.okta_idp_arn}"
}

output "okta_assume_role_statement" {
  value = "${module.okta_child_setup.okta_assume_role_statement}"
}

output "sso_role_arns" {
  value = ["${aws_iam_role.sso_role_ec2.arn}", "${aws_iam_role.sso_role_admin.arn}"]
}

