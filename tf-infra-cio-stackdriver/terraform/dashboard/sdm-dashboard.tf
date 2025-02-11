variable "sdm_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "sdm_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/sdm-dashboard.json", { sdm_project_id = var.sdm_project_id })
} 