variable "region" {}

variable "project_id" {}

variable "project_number" {}

variable "cio_gke_private_yul_001_project_id" {}

variable "cio_gke_public_yul_002_project_id" {}

variable "cio_gke_public_yul_002_project_number" {}

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
