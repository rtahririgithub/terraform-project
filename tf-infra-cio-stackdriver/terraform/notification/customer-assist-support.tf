variable "customerassist_enable_notification" {
  type    = bool
  default = true
}

module "customer_assist_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Customer Assist Support"
  type          = "email"
  email_address = "customer-assist-alert-aaaafmz5tmt5gpzqqd3xrlvkrm@telus.org.slack.com"
  enabled       = var.customerassist_enable_notification
}