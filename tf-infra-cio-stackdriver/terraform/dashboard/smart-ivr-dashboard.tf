variable "smart_ivr_project_id" {
  type    = string
  default = ""
}

variable "smart_ivr_ui_raw_bucket" {
  type    = string
  default = ""
}

variable "smart_ivr_dl_pushed_bucket" {
  type    = string
  default = ""
}

resource "google_monitoring_dashboard" "smart_ivr_dashboard" {
  count          = 0
  project        = var.project_id
  dashboard_json = templatefile("${path.module}/smart-ivr-dashboard.json", { smart_ivr_project_id = var.smart_ivr_project_id, env = var.env, smart_ivr_ui_raw_bucket = var.smart_ivr_ui_raw_bucket, smart_ivr_dl_pushed_bucket = var.smart_ivr_dl_pushed_bucket })
}