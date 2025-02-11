variable "dsa_support_email" {
  type = string
}

variable "dsa_enable_notification" {
  type = string
}

module "dsa_support_email_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "Data Strategy & Architecture Support E-mail"
  email_address = var.dsa_support_email
  enabled       = var.dsa_enable_notification
}