variable "d2c_database_id" {
  description = "D2C database id"
  type        = string
  default     = ""
}

variable "d2c_project_id" {
  description = "D2C project id"
  type        = string
  default     = ""
}

locals {
  d2cc_uptime_check_id          = data.terraform_remote_state.uptime.outputs.d2c_uptime_check.d2c-central.uptime_check_id[0]
  d2c_api_proxy_uptime_check_id = data.terraform_remote_state.uptime.outputs.d2c_uptime_check.d2c-api-proxy.uptime_check_id[0]
}

data "google_monitoring_notification_channel" "D2CSupport" {
  display_name = "D2C Support"
  project      = var.project_id
}

module "d2cc_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C Central - Offline (${var.env})"
  condition_display_name = "D2C Central - Offline (${var.env}) For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${local.d2cc_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}

module "d2c_api_proxy_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C API Proxy - Offline (${var.env})"
  condition_display_name = "D2C API Proxy - Offline (${var.env}) For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${local.d2c_api_proxy_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}

module "d2c_one_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C One Web App - Offline (${var.env})"
  condition_display_name = "D2C One Web App - Offline (${var.env}) For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.d2c_uptime_check.d2c-one.uptime_check_id[0]}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}

module "d2c_central_dev_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C Central DEV - Offline (${var.env})"
  condition_display_name = "D2C Central DEV - Offline (${var.env}) For 10 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.d2c_uptime_check.d2c-central-dv.uptime_check_id[0]}\""
  duration               = "600s"
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}

module "d2c_api_proxy_dv_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C API Proxy DEV - Offline (${var.env})"
  condition_display_name = "D2C API Proxy DEV - Offline (${var.env}) For 10 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.d2c_uptime_check.d2c-api-proxy-dv.uptime_check_id[0]}\""
  duration               = "600s"
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}

module "d2c_one_dv_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C One Web App DEV - Offline (${var.env})"
  condition_display_name = "D2C One Web App DEV - Offline (${var.env}) For 10 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.d2c_uptime_check.d2c-one-dv.uptime_check_id[0]}\""
  duration               = "600s"
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}


module "d2c_cloudsql_server_down_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C CloudSQL database: ${var.d2c_database_id} is down"
  condition_display_name = "${var.d2c_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  content                = "CloudSQL database: ${var.d2c_database_id} is down. Please address issue."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.d2c_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "1"
  comparison             = "COMPARISON_LT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = true
}


module "d2c_cloudsql_memory_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C CloudSQL Memory utilization for CloudSQL database: ${var.d2c_database_id}"
  condition_display_name = "Memory utilization for CloudSQL database: ${var.d2c_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  content                = "Memory Utilization for CloudSQL database: ${var.d2c_database_id} is at 90%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.d2c_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.9"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "300s"
  enabled                = true
}

module "d2c_cloudsql_cpu_utilization_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[D2C CloudSQL] [${var.env}] CPU utilization for CloudSQL database: ${var.d2c_database_id}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.d2c_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  content                = "CPU Utilization for CloudSQL database: ${var.d2c_database_id} is at 80%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.d2c_database_id}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.8"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = true
}

module "d2c_vm_cpu_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C VM CPU Alert Policy (${var.env})"
  condition_display_name = "D2C VM CPU Alert Policy (${var.env}) - CPU utilization at 80% over 15 minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "900s"
  threshold_value        = "0.8"
  filter                 = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.d2c_project_id}\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "60s"
  enabled                = true
}

module "d2c_vm_memory_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C VM Memory Alert Policy (${var.env})"
  condition_display_name = "D2C VM Memory Alert Policy (${var.env}) - Memory at 80% over 15 minutes"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "900s"
  threshold_value        = 80
  filter                 = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.d2c_project_id}\" metric.label.\"state\"=\"used\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "60s"
  enabled                = true
}

module "d2c_vm_disk_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "D2C VM Disk Alert Policy (${var.env})"
  condition_display_name = "D2C VM Disk Alert Policy (${var.env}) - Disk usage is above 90%"
  notif_id               = [data.google_monitoring_notification_channel.D2CSupport.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MEAN"
  cross_series_reducer   = null
  comparison             = "COMPARISON_GT"
  duration               = "900s"
  threshold_value        = 90
  filter                 = "metric.type=\"agent.googleapis.com/disk/percent_used\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.d2c_project_id}\" metric.label.\"device\"=\"root\" metric.label.\"state\"=\"used\""
  group_by_fields        = ["metadata.system_labels.name"]
  alignment_period       = "60s"
  enabled                = true
}

resource "google_monitoring_alert_policy" "d2c_vm_uptime_alert" {
  count        = var.env == "np" ? 1 : 0
  project      = var.project_id
  display_name = "D2C VM Uptime Alert Policy (${var.env})"
  combiner     = "OR"
  conditions {
    display_name = "D2C VM Monitoring Agent Uptime"
    condition_threshold {
      filter          = "metric.type=\"agent.googleapis.com/agent/uptime\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.d2c_project_id}\""
      duration        = "300s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }
  enabled               = false
  notification_channels = [data.google_monitoring_notification_channel.D2CSupport.name]
}