variable "globetrotter_support_email" {}

variable "globetrotter_enable_notification" {}

module "globetrotter_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Globetrotter Support"
  type          = "email"
  email_address = var.globetrotter_support_email
  enabled       = var.globetrotter_enable_notification
}