variable "go_project_id" {
  type = string
}

locals {
  monitored_project_id = var.go_project_id
  monitored_env        = var.env == "np" ? "dv" : "pr"
}

resource "google_monitoring_dashboard" "go" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/go-dashboard.json", { env = local.monitored_env, project_id = local.monitored_project_id })
}

#Ken was here
