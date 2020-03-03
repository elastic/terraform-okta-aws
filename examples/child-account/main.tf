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

terraform {
  required_version = "~> 0.12.20"
}

provider "aws" {
  version = "2.34.0"
  region  = "us-east-1"
}

module "okta_child_setup" {
  source                 = "../../modules/child"
  idp_name               = "DemoOkta2"
  idp_metadata           = file(var.idp_metadata_file)
  master_accounts        = var.master_accounts
}

// create a role that is assumable by Okta
resource "aws_iam_role" "sso_role_ec2" {
  name               = "DemoOkta2EC2ReadOnly"
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
  name   = "DemoOkta2EC2ReadOnlyPolicy"
  role   = aws_iam_role.sso_role_ec2.name
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
  name               = "DemoOkta2Admin"
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
  name   = "DemoOkta2AdminPolicy"
  role   = aws_iam_role.sso_role_admin.name
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
