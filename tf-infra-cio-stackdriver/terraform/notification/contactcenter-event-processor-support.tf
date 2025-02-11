locals {
  contactcenter_event_processor_email_display_name = format("contactcenter_event_processor_GCP_Support-%s Email", upper(var.env))
}

variable "contactcenter_event_processor_enable_notification" {
  type    = string
  default = "false"
}

variable "contactcenter_event_processor_support_email" {
  type    = string
  default = "dlCCAIAPISupport@telus.com"
}

module "contactcenter_event_processor_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = local.contactcenter_event_processor_email_display_name
  email_address = var.contactcenter_event_processor_support_email
  enabled       = var.contactcenter_event_processor_enable_notification
}
