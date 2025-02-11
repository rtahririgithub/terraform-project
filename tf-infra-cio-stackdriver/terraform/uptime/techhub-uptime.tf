variable "techhub_uptime_host" {
  type    = string
  default = ""
}

variable "techhub_uptime_path" {
  type    = string
  default = ""
}

variable "techhub_dv_uptime_host" {
  type    = string
  default = ""
}

variable "techhub_dv_uptime_path" {
  type    = string
  default = ""
}



module "techhub_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "Techhub Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.techhub_uptime_host
  path_name           = var.techhub_uptime_path
}

output "techhub_uptime_check" {
  value = module.techhub_uptime_check
}

module "techhub_dv_uptime_check" {
  count               = var.env == "np" ? 1 : 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "Techhub DV Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.techhub_dv_uptime_host
  path_name           = var.techhub_dv_uptime_path
}

output "techhub_dv_uptime_check" {
  value = module.techhub_dv_uptime_check
}