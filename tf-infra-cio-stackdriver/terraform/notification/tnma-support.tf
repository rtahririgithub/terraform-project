variable "tnma_support_email" {}

variable "tnma_enable_notification" {}

module "tnma_support_channel" {
  #count         = var.env == "np" ? 1 : 0
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TNMA Support"
  type          = "email"
  email_address = var.tnma_support_email
  enabled       = var.tnma_enable_notification
}