# Terraform > Provider
# https://www.terraform.io/docs/modules/index.html
# https://www.terraform.io/docs/providers

# main.tf is intended for individual project configuration.
# Add resources here as required.
locals {
  # ams_uptime_check_id = data.terraform_remote_state.uptime.outputs.ams_uptime_check.uptime_check_id[0]
  ams_uptime_check_id = "fixme"
}

variable "ams_database_id_st" {
  description = "AMS Database ID ST"
  type        = string
  default     = ""
}

variable "ams_project_id" {
  description = "AMS Project ID"
  type        = string
  default     = ""
}

data "google_monitoring_notification_channel" "ams_support" {
  display_name = "AMS Support"
  project      = var.project_id
}

module "ams_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "HTTP(s): AMS Elastic Search ${var.env} Alert Policy"
  condition_display_name = "HTTP(s): AMS Elastic Search ${var.env} Alert Policy"
  notif_id               = [data.google_monitoring_notification_channel.ams_support.name, data.google_monitoring_notification_channel.CloudCoE.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.ams_uptime_check_id}\""
  enabled                = var.enable_notification

}

module "ams_cloudsql_st_cpu_utilization_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "AMS CloudSQL (${var.env}) CPU utilization for CloudSQL database: ${var.ams_database_id_st}"
  condition_display_name = "CPU utilization for CloudSQL database: ${var.ams_database_id_st} over threshold"
  notif_id               = [data.google_monitoring_notification_channel.ams_support.name]
  content                = "CPU Utilization for CloudSQL database: ${var.ams_database_id_st} is at 4%. "
  filter                 = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\" resource.label.database_id=\"${var.ams_database_id_st}\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_MEAN"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_NONE"
  threshold_value        = "0.01"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = true
}