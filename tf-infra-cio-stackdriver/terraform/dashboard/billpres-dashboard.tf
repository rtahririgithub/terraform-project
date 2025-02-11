variable "billpres_billimage_project_id" {
  type = string
}


resource "google_monitoring_dashboard" "billpres" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/billpres-dashboard.json", { project_id = var.billpres_billimage_project_id, env = var.env })
}