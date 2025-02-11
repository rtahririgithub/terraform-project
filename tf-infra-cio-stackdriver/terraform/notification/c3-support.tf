module "c3_support_channel" {
  #TODO: REVIEW IF DUPLICATE
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "C3 Support Channel"
  type          = "email"
  email_address = "dlfamousc3@telus.com"
  enabled       = var.enable_notification
}
