variable "tnma_database_id" {
  description = "TNMA Database ID"
  type        = string
  default     = ""
}

variable "tnma_database_id_dv" {
  description = "TNMA Database ID DV01"
  type        = string
  default     = ""
}

variable "tnma_project_id" {
  description = "TNMA Project ID"
  type        = string
  default     = ""
}

variable "tnma_check_id" {
  default = ""
}

locals {
  tnma_check_id = var.tnma_check_id
  #tnma_check_id = data.terraform_remote_state.uptime.outputs.tnma_uptime_check.uptime_check_id[0]
}

data "google_monitoring_notification_channel" "TNMASupport" {
  display_name = "TNMA Support"
  project      = var.project_id
}


module "tnma_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TNMA DEV - Offline (${var.env})"
  condition_display_name = "TNMA DEV - Offline (${var.env}) For 10 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.TNMASupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${local.tnma_check_id}\""
  duration               = "600s"
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}

module "tnma_api_proxy_dv_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TNMA API Proxy DEV - Offline (${var.env})"
  condition_display_name = "TNMA API Proxy DEV - Offline (${var.env}) For 10 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.TNMASupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${local.tnma_check_id}\""
  duration               = "600s"
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}

module "tnma_dv_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TNMA Web App DEV - Offline (${var.env})"
  condition_display_name = "TNMA Web App DEV - Offline (${var.env}) For 10 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.TNMASupport.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${local.tnma_check_id}\""
  duration               = "600s"
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
}


module "tnma_cloudsql_server_down_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TNMA CloudSQL database: ${var.tnma_database_id} is down"
  condition_display_name = "${var.tnma_database_id} is down"
  notif_id               = [data.google_monitoring_notification_channel.TNMASupport.name]
  content                = "CloudSQL database: ${var.tnma_database_id} is down. Please address issue."
  //filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.tnma_database_id}\""
  filter               = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.tnma_database_id}\""
  policy_comb          = "OR"
  per_series_aligner   = "ALIGN_MEAN"
  alignment_period     = "60s"
  cross_series_reducer = "REDUCE_NONE"
  threshold_value      = "1"
  comparison           = "COMPARISON_LT"
  trigger_count        = "1"
  duration             = "60s"
  enabled              = true
}


module "tnma_cloudsql_memory_utilization_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TNMA CloudSQL Memory utilization for CloudSQL database: ${var.tnma_database_id}"
  condition_display_name = "Memory utilization for CloudSQL database: ${var.tnma_database_id} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.TNMASupport.name]
  content                = "Memory Utilization for CloudSQL database: ${var.tnma_database_id} is at 90%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.tnma_database_id}\""
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

module "tnma_cloudsql_server_down_dv_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TNMA CloudSQL database: ${var.tnma_database_id_dv} is down"
  condition_display_name = "${var.tnma_database_id_dv} is down"
  notif_id               = [data.google_monitoring_notification_channel.TNMASupport.name]
  content                = "CloudSQL database: ${var.tnma_database_id_dv} is down. Please address issue."
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/up\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.tnma_database_id_dv}\""
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


module "tnma_cloudsql_memory_utilization_dv_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TNMA CloudSQL Memory utilization for CloudSQL database: ${var.tnma_database_id_dv}"
  condition_display_name = "Memory utilization for CloudSQL database: ${var.tnma_database_id_dv} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.TNMASupport.name]
  content                = "Memory Utilization for CloudSQL database: ${var.tnma_database_id_dv} is at 90%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.tnma_database_id_dv}\""
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