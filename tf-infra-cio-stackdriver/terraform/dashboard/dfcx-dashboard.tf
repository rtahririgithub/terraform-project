variable "dfcx_project_id" {
  type    = string
  default = ""
}

variable "dfcx_project_number" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "dfcx-dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/dfcx-dashboard.json", { dfcx_project_id = var.dfcx_project_id })
}
