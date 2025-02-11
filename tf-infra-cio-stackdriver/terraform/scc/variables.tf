variable "region" {}

variable "project_id" {}

variable "env" {}

variable "enable_notification" {}

variable "default_channel" {
  type    = string
  default = "Cloud CoE"
}


variable "monitored_projects" {
  description = "The monitored projects"
  type = map(object({
    monitored_project_id = string
    display_names        = list(string)

  }))
}


