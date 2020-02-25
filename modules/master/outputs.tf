output "okta_user" {
  description = "User ARN for Okta user. Access key not set."
  value = "${aws_iam_user.okta_app_user.arn}"
}

output "okta_master_account_id" {
  description = "ID for this account, which is also master"
  value = "${data.aws_caller_identity.current.account_id}"
}
