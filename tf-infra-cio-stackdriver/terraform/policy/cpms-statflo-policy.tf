variable "cpms_statflo_notification_channel_name_list" {
  description = "CPMS statflo notification channel name list"
  type        = list(any)
}

data "google_monitoring_notification_channel" "cpms_statflo_notification_channel_name_list" {
  for_each     = toset(var.cpms_statflo_notification_channel_name_list)
  project      = var.project_id
  display_name = each.key
}

module "cpms_statflo_job_summary_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "CPMS Statflo job summary - Final Job Summary Report"
  condition_display_name = "CPMS Statflo job summary - Final Job Summary Report"
  notif_id               = [for o in data.google_monitoring_notification_channel.cpms_statflo_notification_channel_name_list : o.name]
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_MEAN"
  filter                 = "metric.type=\"logging.googleapis.com/user/cpms/statflo/job_summary\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.job_id", "metric.label.statflo_record_count_sales_reps", "metric.label.statflo_successful_sent_sales_rep_count", "metric.label.statflo_failed_sent_sales_rep_count", "metric.label.statflo_sent_sales_rep_count", ]
  content                = templatefile("${path.module}/cpms-statflo-job-summary-policy.md", {})
}