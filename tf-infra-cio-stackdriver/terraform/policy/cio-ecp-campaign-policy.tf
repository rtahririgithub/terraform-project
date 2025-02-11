variable "ecp_campaign_project_id" {
  description = "ecp_campaign_project id"
  type        = string
}

resource "google_monitoring_alert_policy" "adobe_campaign_resource_constraint" {
  project               = var.project_id
  display_name          = "[ECP Adobe Campaign: YELLOW] [${var.env}] Resource Constrained"
  notification_channels = [data.google_monitoring_notification_channel.ECP.name]
  combiner              = "OR"

  documentation {
    mime_type = "text/markdown"
    content   = "Review specific alert conditions as resource usage is reaching threshold alert levels that could indicate unplanned runaway usage or organic growth that requires imminent planning to increase infrastructure capacity."
  }

  conditions {
    display_name = "Adobe Campaign VM - CPU utilization at 80% over 15 minutes"
    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.ecp_campaign_project_id}\" metric.label.\"instance_name\"!=monitoring.regex.full_match(\"ecp-jpbx.*\")"
      threshold_value = 0.8
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields    = ["metric.labels.instance_name"]
        alignment_period   = "900s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  conditions {
    display_name = "Adobe Campaign VM - Disk utilization exceeds 80% over the past 1 day"
    condition_threshold {
      filter          = "metric.type=\"agent.googleapis.com/disk/percent_used\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.ecp_campaign_project_id}\" metric.label.\"state\"=\"used\" metric.label.\"device\"!=\"tmpfs\""
      threshold_value = 80
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        group_by_fields      = ["resource.label.instance_id"]
        alignment_period     = "86400s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }
    }
  }

  conditions {
    display_name = "Adobe Campaign VM - Memory utilization exceeds 80% over 15 minutes"
    condition_threshold {
      filter          = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\" resource.label.\"project_id\"=\"${var.ecp_campaign_project_id}\" metric.label.\"state\"=\"used\""
      threshold_value = 80
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "900s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  conditions {
    display_name = "Adobe Campaign Cloud SQL - Memory utilization exceeds 80% over 15 minutes"
    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" resource.type=\"cloudsql_database\" resource.label.\"project_id\"=\"${var.ecp_campaign_project_id}\""
      threshold_value = 0.8
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "900s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  conditions {
    display_name = "Adobe Campaign Cloud SQL - CPU utilization exceeds 80% over 15 minutes"
    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" resource.type=\"cloudsql_database\" resource.label.\"project_id\"=\"${var.ecp_campaign_project_id}\""
      threshold_value = 0.8
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "900s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

}

locals {
  adobecampaign_uptime_check_id = data.terraform_remote_state.uptime.outputs.adobecampaign_uptime_check.uptime_check_id[0]
}

module "ac_uptime_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "[ECP Adobe Campaign: RED] [${var.env}] Uptime Check failure Alert Policy"
  condition_display_name = "[ECP Adobe Campaign: RED] [${var.env}] Uptime Check failed"
  notif_id               = [data.google_monitoring_notification_channel.ECP.name]
  trigger_count          = "1"
  per_series_aligner     = "ALIGN_NEXT_OLDER"
  cross_series_reducer   = "REDUCE_COUNT_FALSE"
  duration               = "600s"
  filter                 = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${local.adobecampaign_uptime_check_id}\""
  enabled                = var.enable_notification
  content                = "Adobe Campaign has failed /r/test uptime check over a period of 10 minutes.  The VM health check is configured to recreate the VM if this check fails for more than a minute so something is wrong.  Investigate Cloud Monitoring logs or via SSH to see if Apache is failing to start up."
}