variable "geodata_integration_project_name" {
  type    = string
  default = "geodata_integration_project_name"
}


variable "geodata_integration_project_id" {
  type    = string
  default = "cto-opus-geoblocking-np-9e9d2e"

}

locals {
  opus_squad3_email_display_name = format("Google Cloud Alerting-%s Opus-Squad3 Email", upper(var.env))
}

data "google_monitoring_notification_channel" "opus_squad3_email_display_name" {
  display_name = local.opus_squad3_email_display_name
  project      = var.project_id
}

resource "google_monitoring_alert_policy" "geodata_function_alert_policy" {
  project      = var.project_id
  display_name = "[${var.geodata_integration_project_name}] Cloud Function Policy"
  combiner     = "OR"
  conditions {
    display_name = "${var.geodata_integration_project_name}_error_logs"
    condition_threshold {
      threshold_value = 0
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "resource.type = \"cloud_function\" AND resource.labels.project_id = \"${var.geodata_integration_project_id}\" AND metric.type = \"logging.googleapis.com/log_entry_count\" AND metric.labels.severity = one_of(\"ERROR\", \"WARNING\")"

      aggregations {
        alignment_period = "60s" #1 hours
      }
    }
  }
  documentation {
    mime_type = "text/markdown"
    content   = <<-EOT
    # Logging Error
    Cloud function execution failed
    EOT
  }
  enabled               = true
  notification_channels = [data.google_monitoring_notification_channel.opus_squad3_email_display_name.name]
}

module "geodata_function_alert_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[${var.geodata_integration_project_name}] Cloudfunction failure"
  condition_display_name = "[${var.geodata_integration_project_name}] Cloudfunction failure"
  notif_id               = [local.opus_squad3_email_display_name]
  trigger_count          = "1"
  threshold_value        = "0"
  alignment_period       = "60s"
  per_series_aligner     = "ALIGN_COUNT"
  cross_series_reducer   = "REDUCE_NONE"
  filter                 = "resource.type = \"cloud_function\" AND resource.labels.project_id = \"${var.geodata_integration_project_id}\" AND metric.type = \"logging.googleapis.com/log_entry_count\" AND metric.labels.severity = one_of(\"ERROR\", \"WARNING\")"
  enabled                = "true"
  duration               = "0s"
  content                = "Error with Cloud function ${var.geodata_integration_project_name}"
}
