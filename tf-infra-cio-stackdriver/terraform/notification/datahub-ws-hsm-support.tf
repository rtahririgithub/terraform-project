module "datahub-ws-hsm-data-strategy-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace HSM Data Strategy and Execution"
  type          = "email"
  email_address = "dlHSMDataStrategyandExecution@telus.com"
  enabled       = var.enable_hsm_notification
}

variable "enable_hsm_notification" {
  description = "Boolean to control hsm billing notification"
  type        = string
  default     = "true"
}

