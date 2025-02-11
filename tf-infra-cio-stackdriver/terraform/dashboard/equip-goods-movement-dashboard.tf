variable "gm_container_suffix" {
  type    = string
  default = ""
}

variable "gm_metric_suffix" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "equip_goods_movement_dashboard" {
  project = var.project_id
  dashboard_json = templatefile("${path.module}/equip-goods-movement-dashboard.json", {
    gm_container_suffix = var.gm_container_suffix
    gm_metric_suffix    = var.gm_metric_suffix
  })
}
