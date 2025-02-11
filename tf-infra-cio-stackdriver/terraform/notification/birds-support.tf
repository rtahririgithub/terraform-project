module "birds_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "BIRDS Support E-mail"
  type          = "email"
  email_address = "dlDevOpsBIRDS@telus.com"
  enabled       = var.enable_notification
}
