variable "tnma_uptime_host" {
  default = ""
}

variable "tnma_uptime_path" {
  default = ""
}

module "tnma_uptime_check" {
  count               = var.env == "np" ? 1 : 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TNMA Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.tnma_uptime_host
  path_name           = var.tnma_uptime_path
}

output "tnma_uptime_check" {
  value = module.tnma_uptime_check
}
