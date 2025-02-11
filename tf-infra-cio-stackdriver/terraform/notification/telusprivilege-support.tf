variable "telusprivilege_support_email" {
  type = string
}

variable "telusprivilege_enable_notification" {
  type = string
}

module "telusprivilege_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TELUS Privilege Support"
  type          = "email"
  email_address = var.telusprivilege_support_email
  enabled       = var.telusprivilege_enable_notification
}
