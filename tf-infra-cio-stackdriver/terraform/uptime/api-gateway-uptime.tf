variable "api_gateways" {
  type = map(object({
    display_name = string
    host         = string
    path         = string
  }))
}



module "api_uptime_check" {
  for_each            = var.api_gateways
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = each.value.display_name
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = each.value.host
  path_name           = each.value.path
}

output "api_gateway_uptime_check" {
  value = module.api_uptime_check
}