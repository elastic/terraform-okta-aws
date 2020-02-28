# Okta Single Account Setup

This example setups an AWS account for login via Okta, using both Okta modules [master](../../modules/master) and [child](../../modules/child) in one account. It creates two roles which can be assumed via Okta. 

To run the example:
1) Create an AWS app in Okta.
2) Download the metadata into the file `metadata.xml`
3) Run `make plan` (don't forget to set AWS credentials for Terraform). Sample output:

```bash
$ make plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

data.aws_caller_identity.current: Refreshing state...
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
      name:                   "DemoOktaAdmin"
      path:                   "/"
      unique_id:              <computed>

  + aws_iam_role.sso_role_ec2
      id:                     <computed>
      arn:                    <computed>
      assume_role_policy:     "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    ${module.okta_child_setup.okta_assume_role_statement}\n  ]\n}\n"
      create_date:            <computed>
      force_detach_policies:  "false"
      max_session_duration:   "3600"
      name:                   "DemoOktaEC2ReadOnly"
      path:                   "/"
      unique_id:              <computed>

  + aws_iam_role_policy.sso_role_admin_policy
      id:                     <computed>
      name:                   "DemoOktaAdminPolicy"
      policy:                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"NotAction\": [\n        \"organizations:*\"\n      ],\n      \"Resource\": \"*\"\n    },\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"organizations:DescribeOrganization\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
      role:                   "DemoOktaAdmin"

  + aws_iam_role_policy.sso_role_ec2_policy
      id:                     <computed>
      name:                   "DemoOktaEC2ReadOnlyPolicy"
      policy:                 "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"ec2:*\"\n      ],\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
      role:                   "DemoOktaEC2ReadOnly"

  + module.okta_child_setup.aws_iam_saml_provider.okta_saml_provider
      id:                     <computed>
      arn:                    <computed>
      name:                   "DemoOkta"
      saml_metadata_document: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><md:EntityDescriptor...>...</md:EntityDescriptor>"
      valid_until:            <computed>

  + module.okta_master_setup.aws_iam_user.okta_app_user
      id:                     <computed>
      arn:                    <computed>
      force_destroy:          "false"
      name:                   "okta-config-user"
      path:                   "/"
      unique_id:              <computed>

  + module.okta_master_setup.aws_iam_user_policy.okta_app_user_policy
      id:                     <computed>
      name:                   "OktaConfigUserPolicy"
      policy:                 "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n          \"Effect\": \"Allow\",\n          \"Action\": [\n                \"iam:GetAccountSummary\",\n                \"iam:ListRoles\",\n                \"iam:ListAccountAliases\",\n                \"iam:GetUser\",\n                \"sts:AssumeRole\"\n          ],\n          \"Resource\": \"*\"\n        }\n    ]\n}\n"
      user:                   "okta-app-user"


Plan: 7 to add, 0 to change, 0 to destroy.
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

6) Login to your AWS account and generate an access and secret key for the user created above.
7) Use the credentials to configure the AWS Okta app. See the [Okta App Configuration](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#A-step4) docs.
8) Remember to update the IDP Arn in Okta app:
<img width="600px" src="../../img/okta_config_arn.png"/>

9) You should also see the following in the outputs section:

```json
{
    "sso_role_arns": {
        "sensitive": false,
        "type": "list",
        "value": [
            "arn:aws:iam::XXXX:role/DemoOktaEC2ReadOnly",
            "arn:aws:iam::XXXX:role/DemoOktaAdmin"
         ]
    }
}
```
Once you have mapped users to these roles via the Okta, they can assume these two role into AWS!

<img width="500px" src="../../img/aws_login.png"/>
