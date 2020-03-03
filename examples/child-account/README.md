# Okta Child Account Setup

This example setups an AWS account for login via Okta, using the Okta  [child](../../modules/child) module. It creates two roles which can be assumed via Okta. 
The code assumes you've already setup the master account and Okta AWS app.

To run the example:
1) Create an AWS app in Okta and configure the master account.
2) Set the environment variable `TF_VAR_master_account_ids` to master accounts, using format: `'["<MASTER_ACCOUNT_ID>"]'`.
3) Download the metadata into the file `metadata.xml`
4) Run `make plan` (don't forget to set AWS credentials for Terraform). Sample output:

```bash
$ make plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.okta_child_setup.data.aws_iam_policy_document.okta_cross_account_role_assume_policy: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_iam_role.sso_role_admin will be created
  + resource "aws_iam_role" "sso_role_admin" {
      + arn                   = (known after apply)
      + assume_role_policy    = (known after apply)
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 3600
      + name                  = "DemoOkta2Admin"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # aws_iam_role.sso_role_ec2 will be created
  + resource "aws_iam_role" "sso_role_ec2" {
      + arn                   = (known after apply)
      + assume_role_policy    = (known after apply)
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 3600
      + name                  = "DemoOkta2EC2ReadOnly"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # aws_iam_role_policy.sso_role_admin_policy will be created
  + resource "aws_iam_role_policy" "sso_role_admin_policy" {
      + id     = (known after apply)
      + name   = "DemoOkta2AdminPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Effect    = "Allow"
                      + NotAction = [
                          + "organizations:*",
                        ]
                      + Resource  = "*"
                    },
                  + {
                      + Action   = [
                          + "organizations:DescribeOrganization",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = "DemoOkta2Admin"
    }

  # aws_iam_role_policy.sso_role_ec2_policy will be created
  + resource "aws_iam_role_policy" "sso_role_ec2_policy" {
      + id     = (known after apply)
      + name   = "DemoOkta2EC2ReadOnlyPolicy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "ec2:*",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = "DemoOkta2EC2ReadOnly"
    }

  # module.okta_child_setup.aws_iam_role.okta_cross_account_role[0] will be created
  + resource "aws_iam_role" "okta_cross_account_role" {
      + arn                   = (known after apply)
      + assume_role_policy    = jsonencode(
            {
              + Statement = [
                  + {
                      + Action    = "sts:AssumeRole"
                      + Effect    = "Allow"
                      + Principal = {
                          + AWS = "YYYYY"
                        }
                      + Sid       = ""
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + create_date           = (known after apply)
      + force_detach_policies = false
      + id                    = (known after apply)
      + max_session_duration  = 3600
      + name                  = "Okta-Idp-cross-account-role"
      + path                  = "/"
      + unique_id             = (known after apply)
    }

  # module.okta_child_setup.aws_iam_role_policy.okta_cross_account_role_policy[0] will be created
  + resource "aws_iam_role_policy" "okta_cross_account_role_policy" {
      + id     = (known after apply)
      + name   = "Okta-Idp-cross-account-role-policy"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = [
                          + "iam:ListRoles",
                          + "iam:ListAccountAliases",
                        ]
                      + Effect   = "Allow"
                      + Resource = "*"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
      + role   = (known after apply)
    }

  # module.okta_child_setup.aws_iam_saml_provider.okta_saml_provider will be created
  + resource "aws_iam_saml_provider" "okta_saml_provider" {
      + arn                    = (known after apply)
      + id                     = (known after apply)
      + name                   = "DemoOkta2"
      + saml_metadata_document = <<~EOT
            <?xml version="1.0" encoding="UTF-8"?><md:EntityDescriptor entityID="http://www.okta.com/..." 
            ...
            </md:EntityDescriptor>
        EOT
      + valid_until            = (known after apply)
    }

Plan: 7 to add, 0 to change, 0 to destroy.
```

5) Run `make apply` -  this runs Terraform apply operation.
6) Head over to Okta and configure your app according to [these instructions](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#A-step4). 
7) Run `make output` which generates the file `output_example.json`. You should also see the following in the outputs section:

```json
{
  "sso_role_arns": {
    "sensitive": false,
    "type": [
      "tuple",
      [
        "string",
        "string"
      ]
    ],
    "value": [
      "arn:aws:iam::XXXXX:role/DemoOkta2EC2ReadOnly",
      "arn:aws:iam::XXXXX:role/DemoOkta2Admin"
    ]
  }
}
```
Once you have mapped users to these roles via the Okta, they can assume these two role into AWS!

<img width="500px" src="../../img/aws_login_2.png"/>
