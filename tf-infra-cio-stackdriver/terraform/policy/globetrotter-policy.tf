variable "globetrotter_project_id" {
  type = string
}

variable "globetrotter_enable_policy" {
  type = string
}

locals {
  globetrotter_check_id = data.terraform_remote_state.uptime.outputs.globetrotter_uptime_check.uptime_check_id[0]
  globetrotter_env      = var.env == "np" ? "np" : "pr"

}

data "google_monitoring_notification_channel" "globetrotter_support" {
  display_name = "Globetrotter Support"
  project      = var.project_id
}

module "globetrotter_cpu_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Globetrotter] [${local.globetrotter_env}] CPU Alert Policy"
  condition_display_name = "[Globetrooter] VM [${local.globetrotter_env}] - CPU utilization at 90% over 15 minutes"
  notif_id               = [data.google_monitoring_notification_channel.globetrotter_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "0s"
  threshold_value        = "0.9"
  filter                 = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.globetrotter_project_id}\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "900s"
  enabled                = var.globetrotter_enable_policy
}

module "globetrotter_memory_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Globetrotter] [${local.globetrotter_env}] Memory Alert Policy"
  condition_display_name = "[Globetrotter] VM [${local.globetrotter_env}] - Memory at 80% over 15 minutes"
  notif_id               = [data.google_monitoring_notification_channel.globetrotter_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "0s"
  threshold_value        = 80
  filter                 = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.globetrotter_project_id}\" metric.label.\"state\"=\"used\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "900s"
  enabled                = var.globetrotter_enable_policy
}

module "globetrotter_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Globetrotter] [${local.globetrotter_env}] Uptime Check failure Alert Policy"
  condition_display_name = "[Globetrotter] [${local.globetrotter_env}] Uptime Check failed"
  notif_id               = [data.google_monitoring_notification_channel.globetrotter_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  duration               = "300s"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.globetrotter_check_id}\""
  enabled                = var.globetrotter_enable_policy
  content                = "Globetrotter has failed /r/test uptime check over a period of 5 minutes.  Investigate Cloud Monitoring logs or via RDP to see if Globetrotter (Migrator GT) is failing to start up."
}