variable "myworld_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "myworld" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/myworld-dashboard.json", { project_id = var.project_id, myworld_project_id = var.myworld_project_id, env = var.env })
}


