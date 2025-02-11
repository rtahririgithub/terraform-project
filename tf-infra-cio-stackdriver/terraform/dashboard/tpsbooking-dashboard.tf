variable "tpsbooking_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "tpsbooking_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/tpsbooking-dashboard.json", { tpsbooking_project_id = var.tpsbooking_project_id })
}