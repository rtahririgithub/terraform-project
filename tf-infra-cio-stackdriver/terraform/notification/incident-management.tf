module "incident_management_channel" {
  source       = "git::ssh://git@github.com/telus/tf-module-gcp-notification-channel?ref=v0.0.2"
  project_id   = var.project_id
  display_name = "TrueSight Incident Receiver"
  type         = "pubsub"
  enabled      = var.enable_notification
  pubsub_topic = "projects/${var.project_id}/topics/stackdriver-incident-${var.env}"
}