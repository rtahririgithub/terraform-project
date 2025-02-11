variable "region" {}

variable "project_id" {}

variable "project_name" {}

variable "project_number" {}

variable "env" {}

variable "parent_id" {}

variable "domain" {}

variable "fileset" {}

variable "gke_fileset" {}

variable "organization_id" {}

variable "gcp_group_management_sa_token_creators" {
  type = list(string)
}

variable "git_ops_account_id" {

}

variable "gcp_group_mgmt_accnt_id" {
  default = "gcp-group-management"
}
  