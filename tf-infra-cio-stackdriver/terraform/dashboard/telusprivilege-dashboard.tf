variable "telusprivilege_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "telusprivilege_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/telusprivilege-dashboard.json", { telusprivilege_project_id = var.telusprivilege_project_id })
}