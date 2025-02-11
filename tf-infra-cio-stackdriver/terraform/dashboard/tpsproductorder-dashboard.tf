variable "tps_product_order_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "tpsproductorder_dashboard" {
  # Count = 0 means it's disabled for now
  count          = 1
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/tpsproductorder-dashboard.json", { tps_product_order_project_id = var.tps_product_order_project_id })
}