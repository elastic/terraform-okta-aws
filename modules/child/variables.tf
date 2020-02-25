variable "add_cross_account_role" {
  description = "Add cross account role"
  default     = true
}

variable "idp_name" {
  description = "Name for the IAM identity provider"
  default     = "OktaSSODefault"
}

variable "idp_metadata" {
  description = "Metadata for Okta AWS app"
  default     = ""
}

variable "master_accounts" {
  description = "Account IDs of the master accounts (only relevant for connecting multiple accounts)"
  type        = "list"
  default     = []
}
