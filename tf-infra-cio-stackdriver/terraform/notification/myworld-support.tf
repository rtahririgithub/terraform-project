module "myworld_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "MyWorld Support"
  type          = "email"
  email_address = "GISClient@telus.com"
  enabled       = var.enable_notification
}
