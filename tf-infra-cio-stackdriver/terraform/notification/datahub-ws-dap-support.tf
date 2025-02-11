module "datahub-ws-dap-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace DAP Support"
  type          = "email"
  email_address = "usharani.jerath@telus.com"
  enabled       = var.enable_dap_notification
}

variable "enable_dap_notification" {
  description = "Boolean to control DAP billing notification"
  type        = string
  default     = "true"
}
