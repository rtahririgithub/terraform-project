variable "b2b_wls_usage_summary_support_email" {
  type = string
}

variable "b2b_wls_usage_summary_enable_notification" {
  type = string
}

module "b2b_wls_usage_summary_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "Business To Business Wireless Usage Summary Support E-mail"
  type          = "email"
  email_address = var.b2b_wls_usage_summary_support_email
  enabled       = var.b2b_wls_usage_summary_enable_notification
}
