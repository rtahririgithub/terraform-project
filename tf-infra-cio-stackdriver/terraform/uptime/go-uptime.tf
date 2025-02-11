variable "go_uptime_host" {
  type    = string
  default = ""
}

variable "go_uptime_path" {
  type    = string
  default = ""
}



module "go_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "GO Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.go_uptime_host
  path_name           = var.go_uptime_path
}

output "go_uptime_check" {
  value = module.go_uptime_check
}

#Ken was here