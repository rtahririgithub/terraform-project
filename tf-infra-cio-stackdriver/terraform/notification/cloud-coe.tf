module "cloud_coe_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Cloud CoE"
  type          = "email"
  email_address = "dl-cdo-cloudcoe@telus.com"
  enabled       = var.enable_notification
}
