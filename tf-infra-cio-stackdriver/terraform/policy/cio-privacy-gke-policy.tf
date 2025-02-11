variable "notify_privacy_log_url" {
  description = "notify_privacy log url"
  type        = string
}

variable "enable_gke_uptime" {
  description = "enable gke uptime"
  type        = string
}

variable "enable_gke_public_uptime" {
  description = "enable gke public uptime"
  type        = string
  default     = ""
}

variable "gke_public_console_url" {
  description = "gke public console url"
  type        = string
  default     = ""
}

variable "container_env" {
  description = "container env"
  type        = string
  default     = ""
}

resource "google_monitoring_alert_policy" "gke_notify_privacy_uptime" {
  project               = var.project_id
  display_name          = "[Privacy GKE] [${var.env}] notify-privacy container is not running for 10 mins"
  notification_channels = [data.google_monitoring_notification_channel.Privacy.name, data.google_monitoring_notification_channel.TrueSight.name]
  combiner              = "OR"
  enabled               = var.enable_gke_uptime

  conditions {
    display_name = "Container is Down"
    condition_absent {
      filter   = "metric.type=\"kubernetes.io/container/uptime\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"notify-privacy\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\" metadata.system_labels.top_level_controller_type !=\"CronJob\""
      duration = "600s"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["resource.labels.container_name"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = templatefile("${path.module}/cio-privacy-gke-policy.md", { project_id = var.project_id, env = var.env, gke_console_url = var.gke_console_url })
  }
}

#Service Alert: If HTTP 500 errors caused by usage transactions are more than 50%.
resource "google_monitoring_alert_policy" "gke_notify_privacy_usage_events_alert_policy_500" {
  project               = var.project_id
  display_name          = "[notify-privacy] [${var.env}] HTTP:500 errors for usage events"
  notification_channels = [data.google_monitoring_notification_channel.Privacy.name]
  combiner              = "OR"
  conditions {
    display_name = "HTTP:500 errors from Privacy API"
    condition_threshold {
      filter          = "metric.type=\"external.googleapis.com/prometheus/send_request_total\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\" resource.label.\"namespace_name\"=\"notify-privacy\" metric.label.\"http_status\"=\"500\""
      threshold_value = 50
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["metric.label.http_status"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "PrivacyAPI has generated 500 errors more than the usual rate.\n\n- Application may have issues with micro-services or DB.\n\n- To troubleshoot in the log [here](${var.notify_privacy_log_url})."
  }
}

resource "google_monitoring_alert_policy" "gke_notify_privacy_cmp_opt_out_uptime" {
  project               = var.project_id
  display_name          = "[Privacy Public GKE] [${var.env}] CMP Opt Out Web App Container is Down"
  notification_channels = [data.google_monitoring_notification_channel.Privacy.name]
  combiner              = "OR"
  enabled               = var.enable_gke_public_uptime

  conditions {
    display_name = "[Privacy Public GKE] [${var.env}] cmp-unsubscribe container is not running for 10 mins"
    condition_absent {
      filter   = "metric.type=\"kubernetes.io/container/uptime\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"notify-privacy\" resource.label.\"project_id\"=\"${var.cio_gke_public_yul_002_project_id}\" resource.label.\"container_name\"=\"cmp-unsubscribe-${var.container_env}\""
      duration = "600s"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["resource.labels.container_name"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = templatefile("${path.module}/cio-privacy-gke-public-policy.md", { env = var.env, gke_public_console_url = var.gke_public_console_url })
  }
}
