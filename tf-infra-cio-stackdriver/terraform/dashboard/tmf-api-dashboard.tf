variable "tmf_project_id" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "tmf_api_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/tmf-api-dashboard.json", { tmf_project_id = var.tmf_project_id })
}
