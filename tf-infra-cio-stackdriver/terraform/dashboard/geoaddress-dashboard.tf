variable "geoaddress_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "geoaddress" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/geoaddress-dashboard.json", {})
}


