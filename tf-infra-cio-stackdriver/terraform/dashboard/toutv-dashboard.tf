variable "toutv_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "toutv_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/toutv-dashboard.json", { toutv_project_id = var.toutv_project_id })
}