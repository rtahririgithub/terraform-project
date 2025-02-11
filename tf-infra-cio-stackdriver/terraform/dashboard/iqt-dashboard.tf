variable "iqt_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "iqt_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/iqt-dashboard.json", { iqt_project_id = var.iqt_project_id })
}