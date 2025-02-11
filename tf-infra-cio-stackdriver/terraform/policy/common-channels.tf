data "google_monitoring_notification_channel" "CloudCoE" {
  display_name = "Cloud CoE"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "Orion" {
  display_name = "Orion Alerts"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "TrueSight" {
  display_name = "TrueSight Incident Receiver"
  project      = var.project_id
}

data "google_monitoring_notification_channel" "ECP" {
  display_name = format("ECP Notification Channel-%s Viewer", upper(var.env))
  project      = var.project_id
}

data "google_monitoring_notification_channel" "Privacy" {
  display_name = format("ECP Privacy Channel-%s Viewer", upper(var.env))
  project      = var.project_id
}
