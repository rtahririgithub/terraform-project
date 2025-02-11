variable "onlinemz_support_email" {
  type    = string
  default = ""
}

variable "onlinemz_enable_notification" {
  type    = string
  default = false
}

module "onlinemz_notification_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "OnlineMz Support DL"
  type          = "email"
  email_address = var.onlinemz_support_email
  enabled       = var.onlinemz_enable_notification
}
