resource "google_monitoring_dashboard" "asn_equip_inventory_load" {
  count          = var.env == "np" ? 1 : 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/equip-inventory-load-dashboard.json", { project_id = var.project_id })
}
