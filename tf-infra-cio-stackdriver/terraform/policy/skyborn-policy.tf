variable "skyborn_project_id" {
  type = string
}

locals {
  skyborn_pr_check_id = data.terraform_remote_state.uptime.outputs.skyborn_uptime_check.uptime_check_id[0]
  skyborn_check_id    = var.env == "np" ? "skyborn-uptime-check-9HH2nA_r5q0" : local.skyborn_pr_check_id
  skyborn_env         = var.env == "np" ? "np" : "pr"

}

data "google_monitoring_notification_channel" "skyborn_support" {
  display_name = "Skyborn Support"
  project      = var.project_id
}

module "skyborn_cpu_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Skyborn] [${local.skyborn_env}] CPU Alert Policy"
  condition_display_name = "[Skyborn] VM [${local.skyborn_env}] - CPU utilization at 90% over 30 minutes"
  notif_id               = [data.google_monitoring_notification_channel.skyborn_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "0s"
  threshold_value        = "0.9"
  filter                 = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.skyborn_project_id}\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "1800s"
  enabled                = true
}

module "skyborn_memory_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Skyborn] [${local.skyborn_env}] Memory Alert Policy"
  condition_display_name = "[Skyborn] VM [${local.skyborn_env}] - Memory at 80% over 15 minutes"
  notif_id               = [data.google_monitoring_notification_channel.skyborn_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "0s"
  threshold_value        = 80
  filter                 = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.skyborn_project_id}\" metric.label.\"state\"=\"used\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "900s"
  enabled                = true
}

module "skyborn_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Skyborn] [${local.skyborn_env}] Uptime Check failure Alert Policy"
  condition_display_name = "[Skyborn] [${local.skyborn_env}] Uptime Check failed"
  notif_id               = [data.google_monitoring_notification_channel.skyborn_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  duration               = "300s"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.skyborn_check_id}\""
  enabled                = var.enable_notification
  content                = "Skyborn has failed /r/test uptime check over a period of 5 minutes.  Investigate Cloud Monitoring logs or via RDP to see if Skyborn (Migrator Gmail) is failing to start up."
}
