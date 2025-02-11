locals {
  uom_uptime_check_id = data.terraform_remote_state.uptime.outputs.uom_uptime_check.uom-app.uptime_check_id[0]
}

data "google_monitoring_notification_channel" "UomSupport" {
  display_name = "Uom Support"
  project      = var.project_id
}

module "uom_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "UOM App - Offline (${var.env})"
  condition_display_name = "UOM App - Offline (${var.env}) For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.UomSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${local.uom_uptime_check_id}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
  content                = templatefile("${path.module}/uom-policy.md", { project_id = var.project_id, env = var.env, ptenv = (var.env == "np" ? "DV" : "PR") })
}

module "uom_it01_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "UOM App - Offline (${var.env}) IT01"
  condition_display_name = "UOM App - Offline (${var.env}) IT01 For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.UomSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.uom_uptime_check.uom-it01.uptime_check_id[0]}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
  content                = templatefile("${path.module}/uom-policy.md", { project_id = var.project_id, env = var.env, ptenv = "it01" })
}

module "uom_it02_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "UOM App - Offline (${var.env}) IT02"
  condition_display_name = "UOM App - Offline (${var.env}) IT02 For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.UomSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.uom_uptime_check.uom-it02.uptime_check_id[0]}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
  content                = templatefile("${path.module}/uom-policy.md", { project_id = var.project_id, env = var.env, ptenv = "it02" })
}

module "uom_it03_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "UOM App - Offline (${var.env}) IT03"
  condition_display_name = "UOM App - Offline (${var.env}) IT03 For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.UomSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.uom_uptime_check.uom-it03.uptime_check_id[0]}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
  content                = templatefile("${path.module}/uom-policy.md", { project_id = var.project_id, env = var.env, ptenv = "it03" })
}

module "uom_it04_uptime_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "UOM App - Offline (${var.env}) IT04"
  condition_display_name = "UOM App - Offline (${var.env}) IT04 For 5 Minutes"
  notif_id               = [data.google_monitoring_notification_channel.UomSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.\"check_id\"=\"${data.terraform_remote_state.uptime.outputs.uom_uptime_check.uom-it04.uptime_check_id[0]}\""
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  enabled                = true
  content                = templatefile("${path.module}/uom-policy.md", { project_id = var.project_id, env = var.env, ptenv = "it04" })
}

module "uom_api_error_code_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "UOM App - (${var.env}) detect error response from API"
  condition_display_name = "UOM App - (${var.env}) detect error response from API"
  notif_id               = [data.google_monitoring_notification_channel.UomSupport.name, data.google_monitoring_notification_channel.TrueSight.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/uom/error_response_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"offer-uom-app\""
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  group_by_fields        = ["resource.labels.container_name", "metric.label.service_call", "metric.label.url", "metric.label.status", "metric.label.userId", "metric.label.sessionId", "metric.label.clientIP", "metric.label.call_id"]
  duration               = "60s"
  enabled                = true
  content                = templatefile("${path.module}/uom-policy-api.md", { severity = (var.env == "np" ? "WARNING" : "CRITICAL") })
}
