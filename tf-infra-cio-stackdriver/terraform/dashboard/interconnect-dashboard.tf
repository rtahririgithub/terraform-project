resource "google_monitoring_dashboard" "interconnect" {
  count          = var.env == "pr" ? 1 : 0
  project        = var.project_id
  dashboard_json = file("${path.module}/interconnect-dashboard.json")
}


