variable "gke_product_inventory_project_id" {
  type = string
}

resource "google_monitoring_dashboard" "fox_commerce_ordering_dashboard" {
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/fox-commerce-ordering-dashboard.json", { gke_product_inventory_project_id = var.gke_product_inventory_project_id })
}
