data "terraform_remote_state" "uptime" {
  backend = "gcs"
  config = {
    bucket = "tf-state-${var.project_id}"
    prefix = "terraform/${var.env}/uptime"
  }
}