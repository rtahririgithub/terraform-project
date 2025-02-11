module "csag_support_channel" {
  source        = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id    = var.project_id
  display_name  = "CSAG Support"
  type          = "email"
  email_address = "dlCSAg@telus.com"
  enabled       = var.enable_notification
}

data "google_secret_manager_secret_version" "csag_pager_key" {
  project = var.project_id
  secret  = "csag_pager_key"
}

resource "google_monitoring_notification_channel" "csag_critical_pager_support_channel" {
  project      = var.project_id
  display_name = "CSAG Critical Pager Support"
  type         = "pagerduty"
  sensitive_labels {
    service_key = data.google_secret_manager_secret_version.csag_pager_key.secret_data
  }
  enabled = var.enable_notification
}

