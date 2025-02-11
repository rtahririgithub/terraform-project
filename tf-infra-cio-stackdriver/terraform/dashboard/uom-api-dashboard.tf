resource "google_monitoring_dashboard" "uom_api_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/uom-api-dashboard.json", { uom_project_id = var.uom_project_id })
}