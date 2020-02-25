# Okta Child Account Setup

This example setups an AWS account for login via Okta, using the Okta  [child](../../modules/child) module. It creates two roles which can be assumed via Okta. 
The code assumes you've already setup the master account and Okta AWS app.

To run the example:
1) Create an AWS app in Okta and configure the master account.
2) Set the environment variable `TF_VAR_master_account_ids` to master accounts, using format: `[<MASTER_ACCOUNT_ID>]`.
3) Download the metadata into the file `metadata.xml`
4) Run `make plan` (don't forget to set AWS credentials for Terraform). Sample output:

```bash
$ make plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_iam_policy_document.okta_cross_account_role_assume_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  + aws_iam_role.sso_role_admin
      id:                     <computed>
      arn:                    <computed>
      assume_role_policy:     "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    ${module.okta_child_setup.okta_assume_role_statement}\n  ]\n}\n"
      create_date:            <computed>
      force_detach_policies:  "false"
      max_session_duration:   "3600"
      name:                   "DemoOkta2Admin"
      path:                   "/"
      unique_id:              <computed>

  + aws_iam_role.sso_role_ec2
      id:                     <computed>
      arn:                    <computed>
      assume_role_policy:     "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    ${module.okta_child_setup.okta_assume_role_statement}\n  ]\n}\n"
      create_date:            <computed>
      force_detach_policies:  "false"
      max_session_duration:   "3600"
      name:                   "DemoOkta2EC2ReadOnly"
      path:                   "/"
      unique_id:              <computed>

  + aws_iam_role_policy.sso_role_admin_policy
      id:                     <computed>
      name:                   "DemoOkta2AdminPolicy"
      policy:                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"NotAction\": [\n        \"organizations:*\"\n      ],\n      \"Resource\": \"*\"\n    },\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"organizations:DescribeOrganization\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
      role:                   "DemoOkta2Admin"

  + aws_iam_role_policy.sso_role_ec2_policy
      id:                     <computed>
      name:                   "DemoOkta2EC2ReadOnlyPolicy"
      policy:                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ec2:*\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
      role:                   "DemoOkta2EC2ReadOnly"

  + module.okta_child_setup.aws_iam_role.okta_cross_account_role
      id:                     <computed>
      arn:                    <computed>
      assume_role_policy:     "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"AWS\": \"YYYYY\"\n      }\n    }\n  ]\n}"
      create_date:            <computed>
      force_detach_policies:  "false"
      max_session_duration:   "3600"
      name:                   "Okta-Idp-cross-account-role"
      path:                   "/"
      unique_id:              <computed>

  + module.okta_child_setup.aws_iam_role_policy.okta_cross_account_role_policy
      id:                     <computed>
      name:                   "Okta-Idp-cross-account-role-policy"
      policy:                 "{\n      \"Version\": \"2012-10-17\",\n      \"Statement\": [\n          {\n            \"Effect\": \"Allow\",\n            \"Action\": [\n                \"iam:ListRoles\",\n                \"iam:ListAccountAliases\"\n            ],\n            \"Resource\": \"*\"\n        }\n    ]\n}\n"
      role:                   "${aws_iam_role.okta_cross_account_role.id}"

  + module.okta_child_setup.aws_iam_saml_provider.okta_saml_provider
      id:                     <computed>
      arn:                    <computed>
      name:                   "DemoOkta2"
      saml_metadata_document: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><md:EntityDescriptor...>...</md:EntityDescriptor>\n"
      valid_until:            <computed>


Plan: 7 to add, 0 to change, 0 to destroy.
```

5) Run `make apply` -  this runs Terraform apply operation.
6) Head over to Okta and configure your app according to [these instructions](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#A-step4). 
7) Run `make output` which generates the file `output_example.json`. You should also see the following in the outputs section:

```json
{
    "sso_role_arns": {
        "sensitive": false,
        "type": "list",
        "value": [
            "arn:aws:iam::XXXXX:role/DemoOkta2EC2ReadOnly",
            "arn:aws:iam::XXXXX:role/DemoOkta2Admin"
        ]
    }
}
```
Once you have mapped users to these roles via the Okta, they can assume these two role into AWS!

<img width="500px" src="../../img/aws_login_2.png"/>
