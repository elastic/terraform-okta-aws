// Licensed to Elasticsearch B.V. under one or more contributor
// license agreements. See the NOTICE file distributed with
// this work for additional information regarding copyright
// ownership. Elasticsearch B.V. licenses this file to you under
// the Apache License, Version 2.0 (the "License"); you may
// not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// User for configuring the AWS app in Okta
// See docs: https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#A-step3
resource "aws_iam_user" "okta_app_user" {
  name = "${var.user_name}"
}

resource "aws_iam_user_policy" "okta_app_user_policy" {
  name = "OktaConfigUserPolicy"
  user = "${aws_iam_user.okta_app_user.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Effect": "Allow",
          "Action": [
                "iam:GetAccountSummary",
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