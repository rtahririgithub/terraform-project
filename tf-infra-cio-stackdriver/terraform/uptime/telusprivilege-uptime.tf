variable "telusprivilege_uptime_host" {}
variable "telusprivilege_admin_tool_ui_uptime_path" {}
variable "telusprivilege_admin_tool_be_uptime_path" {}
variable "telusprivilege_support_tool_ui_uptime_path" {}
variable "telusprivilege_support_tool_be_uptime_path" {}

# AdminTool
module "telusprivilege_admin_tool_ui_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TELUS Privilege AdminTool UI Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.telusprivilege_uptime_host
  path_name           = var.telusprivilege_admin_tool_ui_uptime_path
}

output "telusprivilege_admin_tool_ui_uptime_check" {
  value = module.telusprivilege_admin_tool_ui_uptime_check
}

module "telusprivilege_admin_tool_be_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TELUS Privilege AdminTool Backend Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.telusprivilege_uptime_host
  path_name           = var.telusprivilege_admin_tool_be_uptime_path
}

output "telusprivilege_admin_tool_be_uptime_check" {
  value = module.telusprivilege_admin_tool_be_uptime_check
}


# SupportTool
module "telusprivilege_support_tool_ui_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TELUS Privilege SupportTool UI Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.telusprivilege_uptime_host
  path_name           = var.telusprivilege_support_tool_ui_uptime_path
}

output "telusprivilege_support_tool_ui_uptime_check" {
  value = module.telusprivilege_support_tool_ui_uptime_check
}

module "telusprivilege_support_tool_be_uptime_check" {
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=v0.5.0%2Btf.0.13.3"
  project             = var.project_id
  uptime_display_name = "TELUS Privilege SupportTool Backend Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.telusprivilege_uptime_host
  path_name           = var.telusprivilege_support_tool_be_uptime_path
}

output "telusprivilege_support_tool_be_uptime_check" {
  value = module.telusprivilege_support_tool_be_uptime_check
}