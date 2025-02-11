variable "birds_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "birds" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/birds-dashboard.json", { project_id = var.project_id, birds_project_id = var.birds_project_id, env = var.env })
}


