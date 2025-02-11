variable "uom_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "uom_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/uom-dashboard.json", { uom_project_id = var.uom_project_id })
}
