variable "region" {}

variable "project_id" {}

variable "project_number" {}

variable "env" {}

variable "enable_notification" {}

variable "cio_gke_private_yul_001_project_id" {}

variable "cio_gke_public_yul_002_project_id" {}

variable "cio_gke_public_yul_002_project_number" {}

variable "git_ops_account_id" {}

variable "builds" {
  type = map(object({
    name = string
    type = string
  }))
  default = {
    "notification" = {
      name = "Notification"
      type = "push"
    },
    "uptime" = {
      name = "Uptime"
      type = "push"
    },
    "policy" = {
      name = "Policy"
      type = "push"
    },
    "dashboard" = {
      name = "Dashboard"
      type = "push"
    },
    "scc" = {
      name = "SCC"
      type = "push"
    },
    "sre" = {
      name = "SRE"
      type = "push"
    }
  }
}