variable "ttv_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "ttv_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/ttv-dashboard.json", { ttv_project_id = var.ttv_project_id })
}