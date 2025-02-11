module "api_gateway_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel"
  project_id    = var.project_id
  display_name  = "API Gateway Kong Support"
  email_address = "dlEnvMgmt-Kong@telus.com"
  enabled       = var.enable_notification
}