variable "tnma_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "tnma_dashboard" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/tnma-dashboard.json", { tnma_project_id = var.tnma_project_id, env = var.env })
}