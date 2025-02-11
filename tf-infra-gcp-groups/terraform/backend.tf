terraform {
  required_version = "1.1.7"
  backend "gcs" {
    bucket = "tf-state-gcp-groups-pr-c6c009"
    prefix = "terraform/pr"
  }
}
