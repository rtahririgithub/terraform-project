variable "kong_project_id" {
  type    = string
  default = ""
}

variable "kong_cluster_id" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "kong-ops-dashboard" {
  count          = 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/kong-ops-dashboard.json", { kong_project_id = var.kong_project_id, kong_cluster_id = var.kong_cluster_id, env = var.env })
}


