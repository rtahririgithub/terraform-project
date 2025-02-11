variable "region" {}

variable "project_id" {}

variable "env" {}

variable "creditmgmt_repo" {}

variable "sync_repo" {}

variable "integ_repo" {}

variable "get_api_repo" {}

variable "audit_sync_repo" {}

variable "asmt_sync_repo" {}

variable "account_sync_repo" {}

variable "cp_sync_repo" {}

variable "cp_data_mig_repo" {}

variable "asmt_data_mig_repo" {}

variable "audit_purge_repo" {}

variable "project_name" {}

variable "db_server_name" {}

variable "db_server_name_new" {}

variable "db_name" {}

variable "kube_namespace" {}

variable "gke_project_id" {}

variable "location" {}

variable "pubsub_default_account" {}

variable "shared_vpc_network" {
  description = "the host network for the database"
  default     = "https://www.googleapis.com/compute/v1/projects/bto-vpc-host-6296f13b/global/networks/bto-vpc-host-network"
}

variable "creditmgmt-writeapi-v2_repo" {}

variable "creditmgmt-getapi-v2_repo" {}

variable "creditmgmt-audit-prg-repo" {}

variable "gke_namespace" {}

variable "db_zonal_type" {}

variable "db_instance_tier" {}



