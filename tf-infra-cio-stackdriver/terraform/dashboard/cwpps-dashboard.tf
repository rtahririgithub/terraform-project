variable "cwpps_project_id" {
  type    = string
  default = ""
}


resource "google_monitoring_dashboard" "cwpps_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/cwpps-dashboard.json", { cwpps_project_id = var.cwpps_project_id })
}
