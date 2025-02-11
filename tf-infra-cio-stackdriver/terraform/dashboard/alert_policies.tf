data "external" "alert_policies" {
  program = ["bash", "${path.module}/getAlertPolicies.sh"]
  query = {
    env        = var.env
    project_id = var.project_id
    state      = "policy"
  }
}