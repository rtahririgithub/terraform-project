variable "migrator_uptime_host" {}

variable "migrator_uptime_path" {}



module "migrator_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "Migrator Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.migrator_uptime_host
  path_name           = var.migrator_uptime_path
}

output "migrator_uptime_check" {
  value = module.migrator_uptime_check
}