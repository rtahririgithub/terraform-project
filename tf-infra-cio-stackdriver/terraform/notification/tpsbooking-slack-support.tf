locals {
  tpsbooking_slack_display_name = format("Google Cloud Alerting-%s TPS Booking UI Slack", upper(var.env))
}

variable "tpsbooking_support_slack_channel_name" {
  type = string
}
variable "tpsbooking_enable_notification_slack" {
  type = string
}
data "google_secret_manager_secret_version" "tps-booking-slack-secret" {
  project = var.project_id
  secret  = "tps-booking-slack-secret"
}

resource "google_monitoring_notification_channel" "tpsbooking_support_slack_channel" {
  display_name = local.tpsbooking_slack_display_name
  type         = "slack"
  project      = var.project_id
  labels = {
    "channel_name" = var.tpsbooking_support_slack_channel_name
  }
  sensitive_labels {
    auth_token = data.google_secret_manager_secret_version.tps-booking-slack-secret.secret_data
  }
  enabled = var.tpsbooking_enable_notification_slack
}


