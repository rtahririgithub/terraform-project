variable "adobecampaign_uptime_host" {
  type = string
}

variable "adobecampaign_uptime_path" {
  type    = string
  default = "/r/test"
}

module "adobecampaign_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "Adobe Campaign Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = "300s"
  host_monitored      = var.adobecampaign_uptime_host
  path_name           = var.adobecampaign_uptime_path
}

output "adobecampaign_uptime_check" {
  value = module.adobecampaign_uptime_check
}