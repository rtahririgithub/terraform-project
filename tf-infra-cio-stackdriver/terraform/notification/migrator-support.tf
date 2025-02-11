variable "migrator_support_email" {}

variable "migrator_enable_notification" {}

module "migartor_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Migrator Support"
  type          = "email"
  email_address = var.migrator_support_email
  enabled       = var.migrator_enable_notification

}