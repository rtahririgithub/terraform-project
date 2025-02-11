variable "csag_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "csag_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/csag-dashboard.json", { csag_project_id = var.csag_project_id })
}
