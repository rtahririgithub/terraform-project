variable "cto_opus_reco_project_name" {
  type    = string
  default = ""
}

data "google_monitoring_notification_channel" "dataflow_notification_info" {
  display_name = "Recognition support E-mail"
  project      = var.project_id
}

module "datafow_policy" {
  count                  = 0
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = "Dataflow job is not longer running"
  condition_display_name = "Dataflow job is not longer running"
  notif_id               = [data.google_monitoring_notification_channel.dataflow_notification_info.name]
  content                = "Dataflow job is broken"
  filter                 = "metric.type=\"dataflow.googleapis.com/job/is_failed\" resource.type=\"dataflow_job\" resource.labels.project_id = \"${var.cto_opus_reco_project_name}\""
  duration               = "300s"
  trigger_count          = "1"
  threshold_value        = "1"
  enabled                = true
}
