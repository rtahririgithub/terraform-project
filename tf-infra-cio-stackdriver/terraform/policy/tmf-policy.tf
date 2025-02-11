

data "google_monitoring_notification_channel" "TMFSupport" {
  display_name = "TMS Team"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "tmf_pubsub_support" {
  display_name = "TMF Pubsub Support"
  project      = var.project_id
}


module "tmf_api_error_response_count_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TMF App - (${var.env}) detect error response count from API"
  condition_display_name = "TMF App - (${var.env}) detect error response count from API"
  notif_id               = [data.google_monitoring_notification_channel.TMFSupport.name, data.google_monitoring_notification_channel.tmf_pubsub_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/tmf/tmf_api_error_response_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"campaign-recommendation-mgmt\""
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "150"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "180s"
  enabled                = true
  content                = templatefile("${path.module}/tmf-policy-api.md", { severity = (var.env == "np" ? "WARNING" : "CRITICAL") })
}

module "tmf_api_error_response_time_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TMF App - (${var.env}) detect error response time from API"
  condition_display_name = "TMF App - (${var.env}) detect error response time from API"
  notif_id               = [data.google_monitoring_notification_channel.TMFSupport.name, data.google_monitoring_notification_channel.tmf_pubsub_support.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/tmf/tmf_api_error_response_time\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"campaign-recommendation-mgmt\""
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "150"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "180s"
  enabled                = true
  content                = templatefile("${path.module}/tmf-policy-api-error-time.md", { severity = (var.env == "np" ? "WARNING" : "CRITICAL") })
}

module "nba_api_error_response_appliation_start" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "TMF App - (${var.env}) detect error Application start from API"
  condition_display_name = "TMF App - (${var.env}) detect error Application start from API"
  notif_id               = [data.google_monitoring_notification_channel.TMFSupport.name]
  filter                 = "metric.type=\"logging.googleapis.com/user/tmf/nba_error_api\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"campaign-recommendation-mgmt\""
  per_series_aligner     = "ALIGN_COUNT"
  alignment_period       = "60s"
  cross_series_reducer   = "REDUCE_COUNT"
  threshold_value        = "2"
  comparison             = "COMPARISON_GT"
  trigger_count          = "1"
  duration               = "60s"
  enabled                = true
  content                = templatefile("${path.module}/tmf-policy-api-error-time.md", { severity = (var.env == "np" ? "WARNING" : "CRITICAL") })
}
