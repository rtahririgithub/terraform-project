terraform {
  required_version = "0.13.3"
  backend "gcs" {
    bucket = "tf-state-cio-stackdriver-np-b75434"
    prefix = "terraform/np/uptime"
  }
}




