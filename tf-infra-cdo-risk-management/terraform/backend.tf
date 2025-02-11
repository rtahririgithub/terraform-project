terraform {
  required_version = "0.14.9"
  backend "gcs" {
    bucket = "tf-state-cdo-risk-management-np-602b05"
    prefix = "terraform/np"
  }
}
