variable "mtelus_enable_alert" {
  description = "enable the alert"
  type        = string
}

variable "mtelus_project_id" {
  type = string
}

data "google_monitoring_notification_channel" "mtelus_support" {
  display_name = "MTelus Support"
  project      = var.project_id
}

# All pods 'Error' and 'Exception' in logs alert
module "mtelus_error_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "MTelus Errors"
  condition_display_name = "MTelus Errors"
  notif_id               = [data.google_monitoring_notification_channel.mtelus_support.name]
  content                = "MTelus error occured. Service ($${resource.labels.container_name}).\n\n metric_type=$${metric.type}\n\n metric_name=$${metric.display_name}\n\n policy=$${policy.name}\n\n policy_name=$${policy.display_name}\n\n project=$${project}\n\n resource_project=$${resource.project}\n\n Service name=$${resource.labels.container_name}"
  filter                 = "metric.type=\"logging.googleapis.com/user/mtelus/error_count\" resource.type=\"k8s_container\""
  policy_comb            = "OR"
  per_series_aligner     = "ALIGN_DELTA"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_SUM"
  threshold_value        = "0"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = var.mtelus_enable_alert
}

