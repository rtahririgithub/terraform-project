# Alert Policy for NP and PR Envs - Yaraworks
variable "yaraworks_project_id" {
  type    = string
  default = ""
}

data "google_monitoring_notification_channel" "yw_notification_channel" {
  display_name = "Yaraworks Support"
  project      = var.project_id
}

resource "google_monitoring_alert_policy" "yaraworks_alert_policy" {
  count        = var.env == "np" ? 1 : 0
  project      = var.project_id
  display_name = "Yaraworks (${var.env}) ETL Function Critical Alerts"
  combiner     = "OR"
  conditions {
    display_name = "Yaraworks (${var.env}) ETL Function Critical Alerts"
    condition_monitoring_query_language {
      query    = <<-EOT
        fetch global
        | metric 'logging.googleapis.com/log_entry_count'
        | filter resource.project_id == '${var.yaraworks_project_id}'
          && (metric.log !~ 'cloudaudit.*'
          && (metric.severity == 'CRITICAL' || metric.severity == 'ERROR'))
        | group_by 1m, [row_count: max(val())]
        | every 1m
        | condition row_count > 0 '1'
      EOT
      duration = "0s"
      trigger {
        count = 1
      }
    }
  }

  alert_strategy {
    auto_close = "43200s" # 12h
  }

  documentation {
    mime_type = "text/markdown"
    content   = "These are critical and error severity errors in (${var.env}) environment. They usually means data is not well formed in Centerstone or we have some issues with Neo4j. Please fix source data."
  }

  enabled               = "true"
  notification_channels = [data.google_monitoring_notification_channel.yw_notification_channel.name]
}
