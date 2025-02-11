locals {
  log4j_cve_content = file("${path.module}/log4j-cve.md")
}

data "google_monitoring_notification_channel" "tsirt_incident_handlers" {
  display_name = "TSIRT Incident Handlers"
  project      = var.project_id
}

module "log4j_cve_alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Log4J CVE Exploit Observed"
  condition_display_name = "Log4J CVE Exploit Observed"
  notif_id = [
    data.google_monitoring_notification_channel.tsirt_incident_handlers.name
  ]
  trigger_count        = "1"
  threshold_value      = "0"
  per_series_aligner   = "ALIGN_RATE"
  cross_series_reducer = "REDUCE_SUM"
  comparison           = "COMPARISON_GT"
  alignment_period     = "60s"
  duration             = "60s"
  group_by_fields      = []
  filter               = "resource.type=\"l7_lb_rule\" AND metric.type=\"logging.googleapis.com/user/public-yul-${lower(var.env)}-002/log4j_CVE_2021_44228_indicator\""
  enabled              = false
  content              = local.log4j_cve_content
}
