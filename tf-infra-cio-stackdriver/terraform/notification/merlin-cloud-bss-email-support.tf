locals {
  merlin_cloud_bss_email_display_name = format("Google Cloud Alerting-%s MERLIN Cloud-BSS Email", upper(var.env))
}

variable "merlin_cloud_bss_enable_notification" {
  type = string
}

variable "merlin_cloud_bss_support_email" {
  type = string
}

module "merlin_cloud_bss_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  type          = "email"
  project_id    = var.project_id
  display_name  = local.merlin_cloud_bss_email_display_name
  email_address = var.merlin_cloud_bss_support_email
  enabled       = var.merlin_cloud_bss_enable_notification
}
