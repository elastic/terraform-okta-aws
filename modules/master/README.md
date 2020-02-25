# Okta Master Account Setup

Generates a user in the target account with permissions to list roles and acccount aliases.  
After running this module's code, you should assign the target user an access key for use with Okta AWS app. 

Creates the following: 
* IAM user in target account for use with Okta AWS app
* IAM policy for user which allows only listing roles and account aliases

Used to generate user for Okta to download AWS role. Automates user creation for the step, [generate AWS access key](https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service#A-step3) in Okta setup documentation.  
