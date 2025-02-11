variable "d2c_apps" {
  type = map(object({
    display_name = string
    host         = string
    path         = string
  }))
}

module "d2c_uptime_check" {
  for_each            = var.d2c_apps
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = each.value.display_name
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = each.value.host
  path_name           = each.value.path
}

output "d2c_uptime_check" {
  value = module.d2c_uptime_check
}