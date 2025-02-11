module "datahub-ws-tqbia-support-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace TQBIA Support"
  type          = "email"
  email_address = "frederic.thibodeau@telus.com"
  enabled       = var.enable_tqbia_support
}

variable "enable_tqbia_support" {
  description = "Boolean to control TQBIA notification"
  type        = string
  default     = "true"
}

