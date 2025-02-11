module "datahub-ws-wsoc-support-channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Datahub Workspace WSOC Support"
  type          = "email"
  email_address = "dlsoc2@telus.com"
  enabled       = var.enable_wsoc_support
}

variable "enable_wsoc_support" {
  description = "Boolean to control WSOC notification"
  type        = string
  default     = "true"
}
