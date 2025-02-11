variable "cpms_notification_channel_name_list" {
  description = "CPMS notification channel name list"
  type        = list(any)
}

data "google_monitoring_notification_channel" "cpms_notification_channel_name_list" {
  for_each     = toset(var.cpms_notification_channel_name_list)
  project      = var.project_id
  display_name = each.key
}

module "cpms_coconut_job_summary_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS Coconut job summary - Final Job Summary Report"
  condition_display_name = "CPMS Coconut job summary - Final Job Summary Report"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_notification_channel_name_list : o.name]
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_MEAN"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms-coconut-job-summary\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.job_id", "metric.label.record_count_channel_orgs", "metric.label.record_count_outlet_cores", "metric.label.record_count_sales_reps", "metric.label.sent_channel_orgs_count", "metric.label.sent_outlets_count", "metric.label.sent_sales_reps_count"]
  content                = templatefile("${path.module}/cpms-job-summary-policy.md", {})
}

module "cpms_data_sync_checksum_validadtion_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS data sync checksum validation summary"
  condition_display_name = "CPMS data sync checksum validation summary"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_notification_channel_name_list : o.name]
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_NONE"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms-data-sync-checksum-validation-summary\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.table_mismatch", "metric.label.records_mismatch"]
  content                = templatefile("${path.module}/cpms-data-sync-checksum-validation-summary-policy.md", {})
}

module "cpms_data_sync_record_validadtion_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS data sync record validation alert"
  condition_display_name = "CPMS data sync record validation alert"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_notification_channel_name_list : o.name]
  threshold_value        = "20"
  per_series_aligner     = "ALIGN_PERCENTILE_99"
  cross_series_reducer   = "REDUCE_NONE"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms-data-sync-record-validation\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
}

module "cpms_synthetic_api_response_time_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS synthetic api response time alert"
  condition_display_name = "CPMS synthetic api response time alert"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_notification_channel_name_list : o.name]
  threshold_value        = "8000"
  per_series_aligner     = "ALIGN_DELTA"
  cross_series_reducer   = "REDUCE_MEAN"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms-synthetic-api-response-time\" resource.type=\"k8s_container\""
  group_by_fields        = ["metric.label.API_ID"]
  alignment_period       = "60s"
  content                = "API_ID: $${metric.label.API_ID}"
}

module "cpms_synthetic_api_response_code_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS synthetic api response code alert"
  condition_display_name = "CPMS synthetic api response code alert"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_notification_channel_name_list : o.name]
  threshold_value        = "1"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_MAX"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms-synthetic-api-response-code\" resource.type=\"k8s_container\" metric.label.\"response_code\" != \"200 OK\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.API_ID"]
  content                = "# respond_code not equal to 200, Please address the issue.\n\n API_ID: $${metric.label.API_ID}"
}

module "cpms_synthetic_api_user_login_empty_response_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS synthetic api empty response alert"
  condition_display_name = "CPMS synthetic api empty response alert"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_notification_channel_name_list : o.name]
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_MAX"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms-synthetic-api-user-login-empty-response\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.API_ID"]
  content                = "# API response for specified response node is empty, Please address the issue.\n\n API_ID: $${metric.label.API_ID}"
}

module "cpms_postgres_export_alert_policy" {
  count                  = var.env == "np" ? 1 : 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS postgres export alert"
  condition_display_name = "CPMS postgres export alert"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_notification_channel_name_list : o.name]
  threshold_value        = "1"
  per_series_aligner     = "ALIGN_SUM"
  cross_series_reducer   = "REDUCE_SUM"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms-postgres-export-by-datahub\" resource.type=\"k8s_container\""
  alignment_period       = "82800s"
  content                = "There is more than one extract within 23 hours, please address the issue"
}

