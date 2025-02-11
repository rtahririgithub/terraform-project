variable "region" {}

variable "project_id" {}

variable "env" {}

variable "enable_notification" {}

variable "uptime_default_timeout" {
  type    = string
  default = "10s"
}

variable "uptime_default_period" {
  type    = string
  default = "60s"
}

