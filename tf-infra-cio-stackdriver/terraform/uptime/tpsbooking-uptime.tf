variable "tpsbooking_ui_uptime_host" {
  type    = string
  default = ""
}

module "tpsbooking_ui_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TPS Booking Frontend Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.tpsbooking_ui_uptime_host
  path_name           = "/tpsbooking/version"
}

output "tpsbooking_ui_uptime_check" {
  value = module.tpsbooking_ui_uptime_check
}
