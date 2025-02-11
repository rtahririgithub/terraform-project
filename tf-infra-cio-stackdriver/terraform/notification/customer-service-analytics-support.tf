module "customer-service-analytics-support-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "Customer Service Analytics Support"
  email_address = "dlSA@telus.com"
  enabled       = var.enable_notification
}