locals {
  creditmgmt_email_display_name = format("CreditCollection_GCP_Support-%s Email", upper(var.env))
}

variable "creditmgmt_enable_notification" {
  type = string
}

variable "creditmgmt_support_email" {
  type = string
}

module "creditmgmt_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.creditmgmt_email_display_name
  email_address = var.creditmgmt_support_email
  enabled       = var.creditmgmt_enable_notification
}
