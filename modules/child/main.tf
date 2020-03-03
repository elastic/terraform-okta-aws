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

resource "aws_iam_saml_provider" "okta_saml_provider" {
  name                   = var.idp_name
  saml_metadata_document = var.idp_metadata
}

locals {
  okta_assume_role_statement = <<EOF
{
  "Effect": "Allow",
  "Principal": {
    "Federated": "${aws_iam_saml_provider.okta_saml_provider.arn}"
  },
  "Action": "sts:AssumeRoleWithSAML",
  "Condition": {
    "StringEquals": {
      "SAML:aud": "https://signin.aws.amazon.com/saml"
    }
  }
}
EOF
}

data "aws_iam_policy_document" "okta_cross_account_role_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.master_accounts
    }
  }
}

resource "aws_iam_role" "okta_cross_account_role" {
  count              = (var.add_cross_account_role && (length(var.master_accounts)) > 0 ? 1 : 0)
  // This is a pre-defined/reserved name for Okta setup
  // See: https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#B-step4
  name               = "Okta-Idp-cross-account-role"
  assume_role_policy = data.aws_iam_policy_document.okta_cross_account_role_assume_policy.json
}

resource "aws_iam_role_policy" "okta_cross_account_role_policy" {
  count  =  (var.add_cross_account_role && (length(var.master_accounts) > 0) ? 1 : 0)
  name   = "Okta-Idp-cross-account-role-policy"
  role   = aws_iam_role.okta_cross_account_role[count.index].id
  policy = <<-EOF
{
      "Version": "2012-10-17",
      "Statement": [
          {
            "Effect": "Allow",
            "Action": [
                "iam:ListRoles",
                "iam:ListAccountAliases"
            ],
            "Resource": "*"
        }
    ]
}
  EOF
}
