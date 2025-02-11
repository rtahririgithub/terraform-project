variable "reco_env_project_id" {
  description = "Variable used to filter dev and np environment in dashboards"
  default     = ""
  type        = any
}

#module used to create dashboards
resource "google_monitoring_dashboard" "cto_opus_reco_dashboard" {
  for_each       = var.reco_env_project_id
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/cto-opus-reco.json", { reco_env_project_id = each.key, env = each.value.env })
}
