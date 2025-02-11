variable "rtp_project_id" {
  type = string
}



resource "google_monitoring_dashboard" "rtp" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/rtp-dashboard.json", { project_id = var.rtp_project_id, env = var.env })
}