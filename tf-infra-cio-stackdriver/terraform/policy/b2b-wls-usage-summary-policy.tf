variable "b2b_wls_usage_summary_enable_alert" {
  description = "enable the alert"
  type        = bool
  default     = false
}

variable "b2b_usage_consumption_gke_project_id" {}

locals {
  b2b_wls_usage_summary_notification_name = "Business To Business Wireless Usage Summary Support E-mail"
  b2b_wls_usage_consumption_env           = var.env == "np" ? "np" : "pr"
}


data "google_monitoring_notification_channel" "b2b_wls_usage_summary" {
  display_name = local.b2b_wls_usage_summary_notification_name
  project      = var.project_id
}

module "b2b_usage_consumption_liveness_alert_policy" {

  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[B2B Usage Consumption] [${upper(local.b2b_wls_usage_consumption_env)}] Liveness Probes"
  condition_display_name = "[B2B Usage Consumption] [${upper(local.b2b_wls_usage_consumption_env)}] Liveness Probes"
  notif_id               = [data.google_monitoring_notification_channel.b2b_wls_usage_summary.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/usage_consumption_b2b/liveness_probe\" AND resource.type=\"k8s_pod\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_RATE"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "180s"
  enabled                = var.b2b_wls_usage_summary_enable_alert
}

