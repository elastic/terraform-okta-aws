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

output "okta_idp_arn" {
  description = "ARN of IAM IDP created by this module"
  value       = aws_iam_saml_provider.okta_saml_provider.arn
}

output "okta_assume_role_statement" {
  description = "Assume role policy statement to be added to roles assumable by IDP"
  value       = local.okta_assume_role_statement
}

output "okta_cross_account_role" {
  description = "Role for listing roles from another account"
  value       = aws_iam_role.okta_cross_account_role.*.arn
}