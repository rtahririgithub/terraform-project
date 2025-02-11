variable "data_subset_project_id" {
  type    = string
  default = "cto-data-subset-np-f7c98f"
}

variable "data_subset_environment" {
  type    = list(string)
  default = ["dev", "prodlike"]
}

resource "google_monitoring_dashboard" "data-subset-dashboards" {
  for_each = toset(var.data_subset_environment)
  project  = var.project_id
  dashboard_json = templatefile("${path.module}/data-subset-dashboard.json", {
    project_id     = var.data_subset_project_id
    env            = each.key
    container-name = (var.env == "np") ? "data-subset-${each.key}-${var.env}" : "data-subset-${each.key}"
  })
}