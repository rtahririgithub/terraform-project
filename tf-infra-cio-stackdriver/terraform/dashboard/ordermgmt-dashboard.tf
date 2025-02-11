variable "ordermgmt_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "ordermgmt_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/ordermgmt-dashboard.json", { ordermgmt_project_id = var.ordermgmt_project_id })
}