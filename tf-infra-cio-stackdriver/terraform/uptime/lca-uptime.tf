variable "lca_uptime_host" {}

variable "lca_uptime_path" {}



module "lca_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "LCA Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.lca_uptime_host
  path_name           = var.lca_uptime_path
}

output "lca_uptime_check" {
  value = module.lca_uptime_check
}