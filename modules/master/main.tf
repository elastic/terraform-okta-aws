// User for configuring the AWS app in Okta
// See docs: https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#A-step3
resource "aws_iam_user" "okta_app_user" {
  name = "${var.user_name}"
}

resource "aws_iam_user_policy" "okta_app_user_policy" {
  name = "Okta-SSO-User-Policy"
  user = "${aws_iam_user.okta_app_user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
              "iam:ListRoles",
              "iam:ListAccountAliases",
              "iam:GetUser",
              "sts:AssumeRole"
          ],
          "Resource": "*"
        }
    ]
}
EOF
}

data "aws_caller_identity" "current" {}