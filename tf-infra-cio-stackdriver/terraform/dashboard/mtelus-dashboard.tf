variable "mtelus_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "mtelus_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/mtelus-dashboard.json", { mtelus_project_id = var.mtelus_project_id })
}