variable "birds_uptime_host" {}

variable "birds_uptime_path" {}



module "birds_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "HTTP(s): BIRDS Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.birds_uptime_host
  path_name           = var.birds_uptime_path
}

output "brids_uptime_check" {
  value = module.birds_uptime_check
}