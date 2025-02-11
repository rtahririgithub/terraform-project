variable "smart_ivr_uptime_host" {
  default = ""
}

variable "smart_ivr_uptime_path" {
  default = ""
}

module "smart_ivr_uptime_check" {
  count               = var.env == "np" ? 1 : 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "SMART IVR Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.smart_ivr_uptime_host
  path_name           = var.smart_ivr_uptime_path
}

output "smart_ivr_uptime_check" {
  value = module.smart_ivr_uptime_check
}