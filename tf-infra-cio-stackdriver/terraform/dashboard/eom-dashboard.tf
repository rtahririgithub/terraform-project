variable "eom_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "eom_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/eom-dashboard.json", { eom_project_id = var.eom_project_id })
}