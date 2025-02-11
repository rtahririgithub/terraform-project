variable "billing_ces_project_id" {
  type = string
}


resource "google_monitoring_dashboard" "billing_ces" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/billing-ces-dashboard.json", { project_id = var.billing_ces_project_id, env = var.env })
}