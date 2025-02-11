variable "vomp_ui_uptime_host" {
  type    = string
  default = ""
}

module "vomp_ui_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "VOMP Frontend Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.vomp_ui_uptime_host
  path_name           = "/version"
}

module "vomp_be_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "VOMP Backend Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.vomp_ui_uptime_host
  path_name           = "/be/version"
}

module "vomp_aizan_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "VOMP Aizan wrapper Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.vomp_ui_uptime_host
  path_name           = "/aizan-wrapper/version"
}

module "vomp_lsr_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "VOMP LSR wrapper Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.vomp_ui_uptime_host
  path_name           = "/lsr-wrapper/version"
}

module "vomp_system_api_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "VOMP System API Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.vomp_ui_uptime_host
  path_name           = "/system-api/version"
}

module "vomp_task_flow_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "VOMP Task flow Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.vomp_ui_uptime_host
  path_name           = "/task-flow/version"
}

module "vomp_event_listener_uptime_check" {
  count               = 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "VOMP Event listener Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.vomp_ui_uptime_host
  path_name           = "/event-listener/version"
}

output "vomp_ui_uptime_check" {
  value = module.vomp_ui_uptime_check
}

output "vomp_be_uptime_check" {
  value = module.vomp_be_uptime_check
}

output "vomp_aizan_uptime_check" {
  value = module.vomp_aizan_uptime_check
}

output "vomp_lsr_uptime_check" {
  value = module.vomp_lsr_uptime_check
}

output "vomp_system_api_uptime_check" {
  value = module.vomp_system_api_uptime_check
}

output "vomp_task_flow_uptime_check" {
  value = module.vomp_task_flow_uptime_check
}

output "vomp_event-listener_uptime_check" {
  value = module.vomp_event_listener_uptime_check
}
