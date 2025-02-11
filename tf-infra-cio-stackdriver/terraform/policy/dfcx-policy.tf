variable "dfcx_enable_alert" {
  description = "enable the alert"
  type        = bool
  default     = false
}

locals {
  dfcx_notification_name = format("DFCX_Support-%s Email", upper(var.env))
}


data "google_monitoring_notification_channel" "acxux_dfcx" {
  display_name = local.dfcx_notification_name
  project      = var.project_id
}

module "acxux_dfcx_warning_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[DFCX] warnings_errors"
  condition_display_name = "[DFCX] warnings_errors"
  notif_id               = [data.google_monitoring_notification_channel.acxux_dfcx.name]
  content                = "DFCX warnings and errors.\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}"
  filter                 = "metric.type=\"logging.googleapis.com/user/dfcx/warning_error_count\" resource.type=\"global\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "6"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.dfcx_enable_alert
}

module "acxux_dfcx_critical_alert_emergency_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[DFCX] critical_alert_emergency"
  condition_display_name = "[DFCX] critical_alert_emergency"
  notif_id               = [data.google_monitoring_notification_channel.acxux_dfcx.name]
  content                = "DFCX warnings and errors.\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}"
  filter                 = "metric.type=\"logging.googleapis.com/user/dfcx/critical_alert_emergency_count\" resource.type=\"global\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "6"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.dfcx_enable_alert
}