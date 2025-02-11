variable "myworld_uptime_host" {}
variable "myworld_uptime_path" {}
variable "myworld_geoserver_uptime_host" {}
variable "myworld_geoserver_uptime_path" {}

module "myworld_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "MyWorld Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.myworld_uptime_host
  path_name           = var.myworld_uptime_path
}

module "myworld_geoserver_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "MyWorld GeoServer Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.myworld_geoserver_uptime_host
  path_name           = var.myworld_geoserver_uptime_path
}

output "myworld_uptime_check" {
  value = module.myworld_uptime_check
}

output "myworld_geoserver_uptime_check" {
  value = module.myworld_geoserver_uptime_check
}