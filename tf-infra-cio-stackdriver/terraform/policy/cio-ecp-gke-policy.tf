variable "gke_console_url" {
  description = "gke console url"
  type        = string
}

variable "cio_gke_private_yul_001_project_id" {
  description = "gke project id"
  type        = string
}

variable "enable_notify_comm_alert" {
  description = "enable notify communication alert"
  type        = string
}

variable "usage_runbook_url" {
  description = "usage runbook url"
  type        = string
}

resource "google_monitoring_alert_policy" "gke_notify_communication_uptime" {
  project               = var.project_id
  display_name          = "[ECP GKE] [${var.env}] notify-communication container is not running for 10 mins"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"
  enabled               = var.enable_notify_comm_alert

  conditions {
    display_name = "Container is Down"
    condition_absent {
      filter   = "metric.type=\"kubernetes.io/container/uptime\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"notify-communication\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
      duration = "600s"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["resource.label.container_name"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "## Container stopped running in namespace notify-communication.\n\nPlease verify the containers status in [GKE Console](${var.gke_console_url})"
  }

}

resource "google_monitoring_alert_policy" "gke_notify_communication_circuitbreaker" {
  project               = var.project_id
  display_name          = "[ECP GKE] [${var.env}] notify-communication circuitbreaker open"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"
  enabled               = var.enable_notify_comm_alert

  conditions {
    display_name = "Circuit Breaker is Open or Half-Open"
    condition_threshold {
      filter          = "metric.type=\"external.googleapis.com/prometheus/resilience4j_circuitbreaker_state\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"notify-communication\" metric.label.\"state\"=monitoring.regex.full_match(\"open|half_open\") resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
      threshold_value = 0
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields = ["metric.label.state",
        "resource.label.container_name"]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "## Circuit Breaker has opened \n\n When the circuit breaker is opened, no calls will be getting through. This is usually an issue from downstream service. Please troubleshoot the problem from the stackdriver log."
  }

}

resource "google_monitoring_alert_policy" "gke_notify_partitionmgmt_monitor" {
  project               = var.project_id
  display_name          = "[ECP GKE] [${var.env}] message service partition CRON Job health"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"
  conditions {
    display_name = "Partition CRON Job"
    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/cio-notification-comm-msg-svc-partitionmgmt/error_count\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"notify-communication\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\""
      threshold_value = 0
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "## Partition CRON Job failure Detected.\n\nPlease verify the containers status in [GKE Console](${var.gke_console_url})"
  }

}

#RED Alert: 0 traffic for past 30 minutes.
resource "google_monitoring_alert_policy" "gke_notify_usage_events_duens_alert_policy_red" {
  project               = var.project_id
  display_name          = "[ECP DUENS: RED] [${var.env}] 0 Usage Events"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"
  enabled               = var.enable_notify_comm_alert

  conditions {
    display_name = "0 Usage Events received from OpenShift DUENS Application for past 30 minutes"
    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/communication-api-sender/oldduens_request_count\" resource.type=\"k8s_container\""
      threshold_value = 1
      duration        = "1800s" #30 minutes
      comparison      = "COMPARISON_LT"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["resource.label.\"container_name\""]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_DELTA"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "DUENS application has not sent any usage events for the past 30 minutes. This could be because:\n\n- Openshift application pods may have crashed.\n\n- Application may have issues with downstream services in SOA.\n\n- Application may have issues accessing KONG and sending communications using CommunicationAPIV2.\n\n\nTo troubleshoot or resolve issues, follow instruction documented in runbook [here](${var.usage_runbook_url})."
  }

}

#YELLOW Alert: Traffic falls below 25% daily average.
resource "google_monitoring_alert_policy" "gke_notify_usage_events_duens_alert_policy_yellow" {
  project               = var.project_id
  display_name          = "[ECP DUENS: YELLOW] [${var.env}] reduced rate of Usage Events"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"
  enabled               = var.enable_notify_comm_alert

  conditions {
    display_name = "Fall in rate of usage events from OpenShift DUENS Application"
    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/communication-api-sender/oldduens_request_count\" resource.type=\"k8s_container\""
      threshold_value = -25
      duration        = "43200s" #12 hours
      comparison      = "COMPARISON_LT"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["resource.label.\"container_name\""]
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  documentation {
    mime_type = "text/markdown"
    content   = "DUENS application has not sent usage events at expected rate. This could be because:\n\n- Openshift application pods may have crashed.\n\n- Application may have issues with downstream services in SOA.\n\n- Application may have issues accessing KONG and sending communications using CommunicationAPIV2.\n\n\nTo troubleshoot or resolve issues, follow instruction documented in runbook [here](${var.usage_runbook_url})."
  }

}

#Service Alert: If HTTP 500 errors caused by usage transactions are more than 50%.
resource "google_monitoring_alert_policy" "gke_notify_usage_events_duens_alert_policy_500" {
  project               = var.project_id
  display_name          = "[ECP DUENS] [${var.env}] HTTP:500 errors for usage events"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"
  enabled               = var.enable_notify_comm_alert

  conditions {
    display_name = "HTTP:500 errors caused by usage events from DUENS Application"
    condition_threshold {
      filter          = "metric.type=\"external.googleapis.com/prometheus/send_request_total\" resource.type=\"k8s_container\" resource.label.\"project_id\"=\"${var.cio_gke_private_yul_001_project_id}\" metric.label.\"application\"=\"DataUsageEventNotificationService\" metric.label.\"http_status\"=\"500\""
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
    content   = "DUENS application has generated 500 errors more than the usual rate. This could be because:\n\n- Upstream services returning incorrect XML payloads.\n\n- Application may have issues with downstream services in SOA.\n\n- Issues with template service not being able to locate the template(s).\n\n\nTo troubleshoot or resolve issues, follow instruction documented in runbook [here](${var.usage_runbook_url})."
  }

}