variable "ecp_batch_msg_job_summary_channel_name_list" {
  description = "ECP SBS Crosssell Batch Message notification channel name list"
  type        = list(any)
  default     = []
}

variable "ecp_batch_msg_extended_channel_name_list" {
  description = "ECP SBS Crosssell Batch Message notification channel name list"
  type        = list(any)
  default     = []
}

variable "ecp_batch_msg_tech_support_channel_name_list" {
  description = "ECP SBS Crosssell Batch Message notification channel name list"
  type        = list(any)
  default     = []
}

variable "no_file_arrival_threashold" {
  description = "ECP SBS Crosssell Batch Message no file arrival threashold"
  type        = string
  default     = "1000"
}

data "google_monitoring_notification_channel" "ecp_batch_msg_job_summary_channel_name_list" {
  for_each     = toset(var.ecp_batch_msg_job_summary_channel_name_list)
  project      = var.project_id
  display_name = each.key
}

data "google_monitoring_notification_channel" "ecp_batch_msg_extended_channel_name_list" {
  for_each     = toset(var.ecp_batch_msg_extended_channel_name_list)
  project      = var.project_id
  display_name = each.key
}

data "google_monitoring_notification_channel" "ecp_batch_msg_tech_support_channel_name_list" {
  for_each     = toset(var.ecp_batch_msg_tech_support_channel_name_list)
  project      = var.project_id
  display_name = each.key
}

module "ecp_batch_msg_job_status" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "ECP SBS Crosssell Batch Message - Final Job Status Report [${var.env}]"
  condition_display_name = "ECP SBS Crosssell Batch Message - Final Job Status Report [${var.env}]"
  notif_id               = [for o in data.google_monitoring_notification_channel.ecp_batch_msg_job_summary_channel_name_list : o.name]
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_COUNT"
  filter                 = "metric.type=\"logging.googleapis.com/user/ecp/batch_msg/job_status\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.OFile", "metric.label.F", "metric.label.S", "metric.label.R", "metric.label.I", "metric.label.T"]
  content                = templatefile("${path.module}/ecp-batch-msg-job-status-policy.md", {})
}

module "ecp_batch_msg_job_processing" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "ECP SBS Crosssell Batch Message - Intermediate Job Processing Report [${var.env}]"
  condition_display_name = "ECP SBS Crosssell Batch Message - Intermediate Job Processing Report [${var.env}]"
  notif_id               = [for o in data.google_monitoring_notification_channel.ecp_batch_msg_tech_support_channel_name_list : o.name]
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_COUNT"
  filter                 = "metric.type=\"logging.googleapis.com/user/ecp/batch_msg/job_processing\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
  group_by_fields        = ["metric.label.OFile", "metric.label.F", "metric.label.S", "metric.label.R", "metric.label.I", "metric.label.T"]
  content                = templatefile("${path.module}/ecp-batch-msg-job-processing-policy.md", {})
}

resource "google_monitoring_alert_policy" "ecp_batch_msg_absent_file" {
  count                 = var.env == "np" ? 1 : 0
  project               = var.project_id
  display_name          = "ECP SBS Crosssell Batch Message - No File Arrival [${var.env}]"
  notification_channels = [for o in data.google_monitoring_notification_channel.ecp_batch_msg_extended_channel_name_list : o.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "# The expected inbound file has not arrived for 25 hours since the last one received."
  }

  conditions {
    display_name = "ECP SBS Crosssell Batch Message - No KB File Arrival [${var.env}]"

    condition_threshold {

      filter          = "metric.type=\"logging.googleapis.com/user/ecp/batch_msg/no_file_arrival\" resource.type=\"k8s_container\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.no_file_arrival_threashold

      aggregations {
        alignment_period     = "90000s" # 25h Maximum google value
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["metric.label.container_name"]
      }
    }
  }
  alert_strategy {
    auto_close = "86400s" # 24h
  }
  enabled = "false"
}

resource "google_monitoring_alert_policy" "ecp_batch_msg_error_rate" {
  project               = var.project_id
  display_name          = "ECP SBS Crosssell Batch Message - Message Processing Error Rate [${var.env}]"
  notification_channels = [for o in data.google_monitoring_notification_channel.ecp_batch_msg_tech_support_channel_name_list : o.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "# A job processing error rate is higher than 10%.    File: $${metric.label.OFile}"
  }

  conditions {
    display_name = "ECP SBS Crosssell Batch Message - Message Processing Error Rate [${var.env}]"

    condition_monitoring_query_language {
      query    = "fetch k8s_container::logging.googleapis.com/user/ecp/batch_msg/job_status | group_by [metric.OFile], 5m, cast_units(max(metric.F)/max(metric.T), '10^2.%') | condition val() > .1"
      duration = "300s"
    }
  }
  enabled = "true"
}

resource "google_monitoring_alert_policy" "ecp_batch_msg_invalid_rate" {
  project               = var.project_id
  display_name          = "ECP SBS Crosssell Batch Message - Message Processing Invalid Rate [${var.env}]"
  notification_channels = [for o in data.google_monitoring_notification_channel.ecp_batch_msg_extended_channel_name_list : o.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "# A job content invalid rate is higher than 10%.    File: $${metric.label.OFile}"
  }

  conditions {
    display_name = "ECP SBS Crosssell Batch Message - Message Processing Invalid Rate [${var.env}]"

    condition_monitoring_query_language {
      query    = "fetch k8s_container::logging.googleapis.com/user/ecp/batch_msg/job_status | group_by [metric.OFile], 5m, cast_units(max(metric.I)/max(metric.T), '10^2.%') | condition val() > .1"
      duration = "300s"
    }
  }
  enabled = "true"
}

module "ecp_batch_msg_processing_error" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "ECP SBS Crosssell Batch Message - Processing Error [${var.env}]"
  condition_display_name = "ECP SBS Crosssell Batch Message - Processing Error [${var.env}]"
  notif_id               = [for o in data.google_monitoring_notification_channel.ecp_batch_msg_tech_support_channel_name_list : o.name]
  threshold_value        = "0"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_COUNT"
  filter                 = "metric.type=\"logging.googleapis.com/user/ecp/batch_msg/processing_error\" resource.type=\"k8s_container\""
  alignment_period       = "60s"
  content                = "# There is error(s) in ECP SBS Crosssell Batch Message Processor.    File: $${metric.label.OFile}"
}

