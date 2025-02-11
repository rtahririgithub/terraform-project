locals {
  contactcenter_customer_info_email_display_name = format("contactcenter_api_GCP_Support-%s Email", upper(var.env))
}

variable "contactcenter_customer_info_enable_notification" {
  type = string
}

variable "contactcenter_customer_info_support_email" {
  type = string
}

module "contactcenter_customer_info_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.contactcenter_customer_info_email_display_name
  email_address = var.contactcenter_customer_info_support_email
  enabled       = var.contactcenter_customer_info_enable_notification
}
