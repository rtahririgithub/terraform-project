#variable "channel_sales_project_id" {
#  type = string
#}

#resource "google_monitoring_dashboard" "channel_sales" {
#  count          = var.env == "np" ? 1 : 0
#  project        = var.project_id
#  dashboard_json = templatefile("${path.module}/channel-sales-dashboard.json", { project_id = var.channel_sales_project_id, env = var.env })
#}
