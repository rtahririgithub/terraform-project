variable "migrator_project_id" {
  type = string
}

variable "policy_enabled" {
  type = bool
}

locals {
  migrator_check_id = data.terraform_remote_state.uptime.outputs.migrator_uptime_check.uptime_check_id[0]
  migrator_env      = var.env == "np" ? "np" : "pr"
}

data "google_monitoring_notification_channel" "migrator_support" {
  display_name = "Migrator Support"
  project      = var.project_id
}

module "migrator_cpu_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Migrator] [${local.migrator_env}] CPU Alert Policy"
  condition_display_name = "[Migrator] VM [${local.migrator_env}] - CPU utilization at 80% over 15 minutes"
  notif_id               = [data.google_monitoring_notification_channel.migrator_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "0s"
  threshold_value        = "0.8"
  filter                 = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.migrator_project_id}\" metric.label.\"instance_name\"=monitoring.regex.full_match(\"cm-primary.*\")"
  group_by_fields        = ["metric.labels.instance_name"]
  alignment_period       = "900s"
  enabled                = var.policy_enabled
}

module "migrator_memory_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Migrator] [${local.migrator_env}] Memory Alert Policy"
  condition_display_name = "[Migrator] VM [${local.migrator_env}] - Memory at 80% over 15 minutes"
  notif_id               = [data.google_monitoring_notification_channel.migrator_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "0s"
  threshold_value        = 80
  filter                 = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.migrator_project_id}\" metric.label.\"state\"=\"used\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "900s"
  enabled                = var.policy_enabled
}

module "migrator_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[Migrator] [${local.migrator_env}] Uptime Check failure Alert Policy"
  condition_display_name = "[Migrator] [${local.migrator_env}] Uptime Check failed"
  notif_id               = [data.google_monitoring_notification_channel.migrator_support.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  duration               = "300s"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.migrator_check_id}\""
  enabled                = var.policy_enabled
  content                = "Cloud Migrator has failed /r/test uptime check over a period of 5 minutes.  Investigate Cloud Monitoring logs or via RDP to see if Cloud Migrator is failing to start up."
}