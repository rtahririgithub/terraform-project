variable "customer_assist_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "customer_assist_dashboard" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/customer-assist-dashboard.json", { customer_assist_project_id = var.customer_assist_project_id })
}