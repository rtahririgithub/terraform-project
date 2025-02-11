variable "apigee_enable_alert" {
  description = "enable the alert"
  type        = bool
  default     = false
}

locals {
  apigee_notification_name = format("Apigee_Support-%s Email", upper(var.env))
}


data "google_monitoring_notification_channel" "axcux_apigee" {
  display_name = local.apigee_notification_name
  project      = var.project_id
}

module "acxux_apigee_exception_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[acxux_apigee_proxies] apigee_proxies_info_exception"
  condition_display_name = "[acxux_apigee_proxies] apigee_proxies_info_exception"
  notif_id               = [data.google_monitoring_notification_channel.axcux_apigee.name]
  content                = "Apigee proxies exception occured.\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}"
  filter                 = "metric.type=\"logging.googleapis.com/user/apigee/error_count\" resource.type=\"api\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_SUM"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "3"
  comparison             = "COMPARISON_GT"
  duration               = "60s"
  trigger_count          = "1"
  enabled                = var.apigee_enable_alert
}