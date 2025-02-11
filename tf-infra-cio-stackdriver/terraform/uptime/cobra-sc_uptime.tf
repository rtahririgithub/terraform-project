variable "cobra_sc_uptime_host" {
  type    = string
  default = ""
}

module "cobra_sc_uptime_check" {
  count               = var.env == "np" ? 1 : 0
  source              = "git::ssh://git@github.com/telus/tf-module-gcp-uptimecheck?ref=master"
  project             = var.project_id
  uptime_display_name = "COBRA SC Uptime Check"
  timeout             = var.uptime_default_timeout
  period              = var.uptime_default_period
  host_monitored      = var.cobra_sc_uptime_host
  path_name           = "/customer/CreditCardSurchargeCalculator/v1/surcharge/payment"
}

output "cobra_sc_uptime_check" {
  value = module.cobra_sc_uptime_check
}