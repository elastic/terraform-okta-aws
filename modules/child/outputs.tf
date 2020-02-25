output "okta_idp_arn" {
  description = "ARN of IAM IDP created by this module"
  value       = "${aws_iam_saml_provider.okta_saml_provider.arn}"
}

output "okta_assume_role_stanza" {
  description = "Assume role stanza to be added to roles assumable by IDP"
  value       = "${local.okta_assume_role_stanza}"
}

output "okta_cross_account_role" {
  description = "Role for listing roles from another account"
  value       = "${aws_iam_role.okta_cross_account_role.*.arn}"
}