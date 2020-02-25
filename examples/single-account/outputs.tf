output "okta_user" {
  description = "User created for setting up AWS Okta app. Please set access key manually."
  value       = "${module.okta_master_setup.okta_user}"
}

output "okta_cross_account_role" {
  value = "${module.okta_child_setup.okta_roles_lister_arn}"
}

output "okta_idp_arn" {
  value = "${module.okta_child_setup.okta_idp_arn}"
}

output "sso_role_arn" {
  value = "${aws_iam_role.sso_role_tester.arn}"
}
