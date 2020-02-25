# Okta Single Account Setup

This example setups an AWS account for login via Okta. It creates a single role `SSOTestRole` which can be assumed via Okta. 

To run the example:
1) Create an AWS app in Okta.
2) Download the metadata into the file `metadata.xml`
3) Run `make plan` (do not forget to set AWS creds in environment). Sample output:

```bash
$ make plan
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_caller_identity.current: Refreshing state...
data.aws_iam_policy_document.okta_roles_lister_assume_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_iam_role.sso_role_tester
      id:                     <computed>
      arn:                    <computed>
      assume_role_policy:     "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [ ,\n    ${module.okta_child_setup.assume_role_stanza}\n  ]\n}\n"
      create_date:            <computed>
      force_detach_policies:  "false"
      max_session_duration:   "3600"
      name:                   "SSOTestRole"
      path:                   "/"
      unique_id:              <computed>

  + aws_iam_role_policy.sso_role_tester_policy
      id:                     <computed>
      name:                   <computed>
      policy:                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"NotAction\": [\n        \"organizations:*\"\n      ],\n      \"Resource\": \"*\"\n    },\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ec2:Decribe*\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
      role:                   "${aws_iam_role.sso_role_tester.id}"

  + module.okta_child_setup.aws_iam_role.okta_roles_lister
      id:                     <computed>
      arn:                    <computed>
      assume_role_policy:     "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"AWS\": \"328738285619\"\n      }\n    }\n  ]\n}"
      create_date:            <computed>
      force_detach_policies:  "false"
      max_session_duration:   "3600"
      name:                   "Okta-Idp-cross-account-role"
      path:                   "/"
      unique_id:              <computed>

  + module.okta_child_setup.aws_iam_role_policy.okta_iam_read_only
      id:                     <computed>
      name:                   "Okta-Idp-cross-account-role-policy"
      policy:                 "{\n      \"Version\": \"2012-10-17\",\n      \"Statement\": [\n          {\n            \"Effect\": \"Allow\",\n            \"Action\": [\n                \"iam:ListRoles\",\n                \"iam:ListAccountAliases\"\n            ],\n            \"Resource\": \"*\"\n        }\n    ]\n}\n"
      role:                   "${aws_iam_role.okta_roles_lister.id}"

  + module.okta_child_setup.aws_iam_saml_provider.okta_saml_provider
      id:                     <computed>
      arn:                    <computed>
      name:                   "OktaDemo"
      saml_metadata_document: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>..."
      valid_until:            <computed>

  + module.okta_master_setup.aws_iam_user.okta_app_user
      id:                     <computed>
      arn:                    <computed>
      force_destroy:          "false"
      name:                   "okta-app-user"
      path:                   "/"
      unique_id:              <computed>

  + module.okta_master_setup.aws_iam_user_policy.okta_app_user_policy
      id:                     <computed>
      name:                   "Okta-SSO-User-Policy"
      policy:                 "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n          \"Effect\": \"Allow\",\n          \"Action\": [\n              \"iam:ListRoles\",\n              \"iam:ListAccountAliases\"\n          ],\n          \"Resource\": \"*\"\n        }\n    ]\n}\n"
      user:                   "okta-app-user"


Plan: 7 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.

```

4) Run `make apply` -  this runs Terraform apply operation. 
5) Run `make output` which generates the file `output_example.json`. You should see the following section in the outputs:

```json
{
 "okta_user": {
        "sensitive": false,
        "type": "string",
        "value": "arn:aws:iam::XXXXX:user/okta-app-user"
    }
}
```

6) Login to your account and generate an access and secret key for the user created above.
7) Use the credentials to configure the AWS Okta app. 
8) You should also see the following in the outputs section:

```json
{
    "sso_role_arn": {
        "sensitive": false,
        "type": "string",
        "value": "arn:aws:iam::XXXXX:role/SSOTestRole"
    }
}
```
You can assume this role now via Okta login!

