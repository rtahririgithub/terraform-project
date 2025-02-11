variable "toutv_ui_uptime_host" {}
variable "toutv_ui_uptime_path" {}
variable "toutv_be_uptime_path" {}
variable "toutv_admin_ui_uptime_host" {}
variable "toutv_admin_ui_uptime_path" {}
variable "toutv_admin_be_uptime_path" {}
variable "toutv_premium_uptime_path" {}

module "toutv_ui_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TouTv UI Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.toutv_ui_uptime_host
  path_name           = var.toutv_ui_uptime_path
}

output "toutv_ui_uptime_check" {
  value = module.toutv_ui_uptime_check
}

module "toutv_be_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TouTv Backend Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.toutv_ui_uptime_host
  path_name           = var.toutv_be_uptime_path
}

output "toutv_be_uptime_check" {
  value = module.toutv_be_uptime_check
}

module "toutv_admin_ui_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TouTv Admin UI Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.toutv_admin_ui_uptime_host
  path_name           = var.toutv_admin_ui_uptime_path
}

output "toutv_admin_ui_uptime_check" {
  value = module.toutv_admin_ui_uptime_check
}

module "toutv_admin_be_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TouTv Admin BE Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.toutv_admin_ui_uptime_host
  path_name           = var.toutv_admin_be_uptime_path
}

output "toutv_admin_be_uptime_check" {
  value = module.toutv_admin_be_uptime_check
}

module "toutv_premium_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TouTv Premium Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.toutv_admin_ui_uptime_host
  path_name           = var.toutv_premium_uptime_path
}

output "toutv_premium_uptime_check" {
  value = module.toutv_premium_uptime_check
}