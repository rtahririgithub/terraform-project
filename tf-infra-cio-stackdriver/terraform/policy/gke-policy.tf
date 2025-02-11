locals {
  public_002_check_id           = data.terraform_remote_state.uptime.outputs.gke_uptime_check.public-yul-002.uptime_check_id[0]
  private_001_check_id          = data.terraform_remote_state.uptime.outputs.gke_uptime_check.private-yul-001.uptime_check_id[0]
  protected_devops_002_check_id = var.env == "np" ? data.terraform_remote_state.uptime.outputs.gke_uptime_check.devops-yul-002.uptime_check_id[0] : "void"
}

module "public_public_002_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-gke-public-yul-002-${var.env}] HTTP(s): Alert Policy"
  condition_display_name = "[cio-gke-public-yul-002-${var.env}] HTTP(s): Alert Policy"
  notif_id               = [data.google_monitoring_notification_channel.CloudCoE.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.public_002_check_id}\""
  enabled                = true
}

module "protected_private_001_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-gke-private-yul-001-${var.env}] HTTP(s): Alert Policy"
  condition_display_name = "[cio-gke-private-yul-001-${var.env}] HTTP(s): Alert Policy"
  notif_id               = [data.google_monitoring_notification_channel.CloudCoE.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.private_001_check_id}\""
  enabled                = true
}

module "protected_devops_002_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[cio-gke-devops-yul-002-${var.env}] HTTP(s): Alert Policy"
  condition_display_name = "[cio-gke-devops-yul-002-${var.env}] HTTP(s): Alert Policy"
  notif_id               = [data.google_monitoring_notification_channel.CloudCoE.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.protected_devops_002_check_id}\""
  enabled                = true
}
