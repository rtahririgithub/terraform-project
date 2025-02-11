module "tsirt_incident_handlers" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "TSIRT Incident Handlers"
  type          = "email"
  email_address = "dltsirtincidenthandlers@telus.com"
  enabled       = var.enable_notification

}