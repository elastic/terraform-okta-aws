variable "idp_metadata_file" {
  description = "Metadata file"
  default     = "metadata.xml"
}

variable "master_account_ids" {
  description = "Okta master account ID"
  type        = "list"
  default     = []
}