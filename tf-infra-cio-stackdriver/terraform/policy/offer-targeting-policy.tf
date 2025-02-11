# Alerting the DSA team when issues are detected with the Offer Targeting API & ETL

variable "offer_targeting_project_id" {
  type = string
}

data "google_monitoring_notification_channel" "offer-targeting-support" {
  display_name = "Data Strategy & Architecture Support E-mail"
  project      = var.project_id
}

resource "google_monitoring_alert_policy" "offer_targeting_etl_alert_policy_absent" {
  project               = var.project_id
  display_name          = "Offer Targeting ETL (${var.env}) Absent"
  notification_channels = [data.google_monitoring_notification_channel.offer-targeting-support.name]
  combiner              = "OR"
  enabled               = true

  conditions {
    display_name = "Offer Targeting ETL (${var.env}) Absent"
    condition_absent {
      filter   = "metric.type=\"logging.googleapis.com/user/mktstrat-offer-targeting/offer-targeting-etl/event_cnt\" resource.type=\"k8s_container\""
      duration = "86400s"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "3600s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
# Offer Targeting ETL (${var.env}) Absent

No status event log message were detected for the Offer Targeting ETL (${var.env}) in the past 24 hours.

Please ensure the data is being transferred to GCS and GKE is configured correctly.
EOT
  }

}

module "offer_targeting_etl_alert_policy_failed" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Offer Targeting ETL (${var.env}) Failed"
  condition_display_name = "Offer Targeting ETL (${var.env}) Failed"
  notif_id               = [data.google_monitoring_notification_channel.offer-targeting-support.name]
  group_by_fields        = ["metric.label.file"]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_NONE"
  filter                 = "metric.type=\"logging.googleapis.com/user/mktstrat-offer-targeting/offer-targeting-etl/event_cnt\" resource.type=\"k8s_container\" metric.label.\"status\"=\"failed\""
  enabled                = true
  content                = <<-EOT
# Offer Targeting ETL (${var.env}) Failed

Transfer of file failed

Filename: $${metric.label.file}
Duration: $${metric.label.duration} seconds

Please resolve the issue ASAP
EOT
}

module "offer_targeting_etl_alert_policy_performance" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Offer Targeting ETL (${var.env}) Performance"
  condition_display_name = "Offer Targeting ETL (${var.env}) Performance"
  notif_id               = [data.google_monitoring_notification_channel.offer-targeting-support.name]
  group_by_fields        = ["metric.label.file"]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_MAX"
  cross_series_reducer   = "REDUCE_NONE"
  filter                 = "metric.type=\"logging.googleapis.com/user/mktstrat-offer-targeting/offer-targeting-etl/event_cnt\" resource.type=\"k8s_container\" metric.label.\"duration\">600"
  enabled                = true
  content                = <<-EOT
# Offer Targeting ETL (${var.env}) Performance Degradation

The file took too long to process

Filename: $${metric.label.file}
Duration: $${metric.label.duration} seconds

Please investigate or re-adjust the threshold.
EOT
}
