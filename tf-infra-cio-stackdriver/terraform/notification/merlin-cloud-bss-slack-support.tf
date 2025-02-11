locals {
  merlin_cloud_bss_slack_display_name = format("Google Cloud Alerting-%s MERLIN Cloud-BSS Slack", upper(var.env))
}

variable "merlin_cloud_bss_support_slack_channel_name" {
  type = string
}
variable "merlin_cloud_bss_enable_notification_slack" {
  type = string
}
data "google_secret_manager_secret_version" "merlin_cloud_bss_secret" {
  project = var.project_id
  secret  = "merlin_cloud_bss_secret"
}

resource "google_monitoring_notification_channel" "merlin_cloud_bss_support_slack_channel" {
  display_name = local.merlin_cloud_bss_slack_display_name
  type         = "slack"
  project      = var.project_id
  labels = {
    "channel_name" = var.merlin_cloud_bss_support_slack_channel_name
  }
  sensitive_labels {
    auth_token = data.google_secret_manager_secret_version.merlin_cloud_bss_secret.secret_data
  }
  enabled = var.merlin_cloud_bss_enable_notification_slack
}