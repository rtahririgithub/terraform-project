module "datahub-ws-tmbbi-support-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace WSOC Support"
  type          = "email"
  email_address = "dlTBMGopalakrishnan@telus.com"
  enabled       = var.enable_tmbbi_support
}

variable "enable_tmbbi_support" {
  description = "Boolean to control TMBBI notification"
  type        = string
  default     = "true"
}
