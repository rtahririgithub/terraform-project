variable "birds_project_id" {
  type = string
}

locals {
  birds_check_id = data.terraform_remote_state.uptime.outputs.brids_uptime_check.uptime_check_id[0]
}

data "google_monitoring_notification_channel" "birds-support" {
  display_name = "BIRDS Support E-mail"
  project      = var.project_id
}

module "birds_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "https: BIRDS ${var.env} alert policy"
  condition_display_name = "https: BIRDS ${var.env} alert policy"
  notif_id               = [data.google_monitoring_notification_channel.birds-support.name, data.google_monitoring_notification_channel.TrueSight.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.birds_check_id}\""
  enabled                = true
  content                = templatefile("${path.module}/birds-policy.md", { project_id = var.birds_project_id, env = var.env })
}