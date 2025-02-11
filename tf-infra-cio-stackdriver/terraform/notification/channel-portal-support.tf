variable "channel_portal_support_email" {
  type    = string
  default = ""
}

variable "channel_portal_enable_notification" {
  type    = string
  default = ""
}

module "channel_portal_email_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "Channel Portal Support Email"
  type          = "email"
  email_address = var.channel_portal_support_email
  enabled       = var.channel_portal_enable_notification
}

data "google_secret_manager_secret_version" "channel_portal_pagerduty_integration_key" {
  count   = var.env == "np" ? 1 : 0
  project = var.project_id
  secret  = "cpl_pagerduty_integration_key"
}

resource "google_monitoring_notification_channel" "channel_portal_critical_pagerduty_support_channel" {
  count        = var.env == "np" ? 1 : 0
  project      = var.project_id
  display_name = "Channel Portal Critical PagerDuty Channel"
  type         = "pagerduty"
  sensitive_labels {
    service_key = data.google_secret_manager_secret_version.channel_portal_pagerduty_integration_key[0].secret_data
  }
  enabled = var.enable_notification
}
