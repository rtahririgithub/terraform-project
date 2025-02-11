variable "iqt_ui_uptime_host" {}
variable "iqt_ui_uptime_path" {}
variable "iqt_be_uptime_path" {}

module "iqt_ui_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "IQT UI Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.iqt_ui_uptime_host
  path_name           = var.iqt_ui_uptime_path
}

output "iqt_ui_uptime_check" {
  value = module.iqt_ui_uptime_check
}

module "iqt_be_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "IQT Backend Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.iqt_ui_uptime_host
  path_name           = var.iqt_be_uptime_path
}

output "iqt_be_uptime_check" {
  value = module.iqt_be_uptime_check
}
