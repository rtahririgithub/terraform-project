module "datahub-ws-tdb2b-analytics-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace TD B2B Analytics Support"
  type          = "email"
  email_address = "dltd-b2b-analytics@telus.com"
  enabled       = var.enable_tdb2b_support
}

variable "enable_tdb2b_support" {
  description = "Boolean to control TD B2B notification"
  type        = string
  default     = "true"
}