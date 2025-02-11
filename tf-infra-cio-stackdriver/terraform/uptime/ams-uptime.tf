variable "ams_uptime_host" {
  type    = string
  default = ""
}

variable "ams_uptime_path" {
  type    = string
  default = ""

}

data "google_secret_manager_secret_version" "ams" {
  project = var.project_id
  secret  = "ams-token"
}

module "ams_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "HTTP(s): AMS Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.ams_uptime_host
  path_name           = var.ams_uptime_path
  headers             = { authorization = "Bearer ${data.google_secret_manager_secret_version.ams.secret_data}" }
}

output "ams_uptime_check" {
  value = module.ams_uptime_check
}