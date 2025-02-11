data "google_monitoring_notification_channel" "ep_cdm_cm_channel" {
  project      = var.project_id
  display_name = "ep-cdm-cm-channel"
}

// ep-cdm-alert-policy - Done via resource instead of module call due to query language unsupported
resource "google_monitoring_alert_policy" "ep_alert_policy" {
  count        = var.env == "np" ? 1 : 0
  combiner     = "OR"
  display_name = "ep-cdm-alert-policy"
  notification_channels = [
    data.google_monitoring_notification_channel.ep_cdm_cm_channel.name
  ]
  project = var.project_id

  alert_strategy {
    auto_close = "604800s"
  }

  conditions {
    display_name = "Kubernetes Container - Uptime"

    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "resource.type = \"k8s_container\" AND (resource.labels.container_name = \"infra-paas-node-starter-st\" AND resource.labels.namespace_name = \"ep-reference-application\") AND metric.type = \"kubernetes.io/container/uptime\""
      threshold_value = 300

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count   = 1
        percent = 0
      }
    }
  }
}