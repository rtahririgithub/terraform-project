variable "vomp_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "vomp_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/vomp-dashboard.json", { vomp_project_id = var.vomp_project_id })
}