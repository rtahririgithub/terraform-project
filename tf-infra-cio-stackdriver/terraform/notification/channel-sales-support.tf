variable "channel_sales_support_email" {
  type = string
}

variable "channel_sales_enable_notification" {
  type = string
}

module "channel_sales_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Channel Sales API Support Channel"
  type          = "email"
  email_address = var.channel_sales_support_email
  enabled       = var.channel_sales_enable_notification
}
