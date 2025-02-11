terraform {
  required_version = "0.13.3"
  backend "gcs" {
    bucket = "tf-state-cio-creditmgmt-np-15dfbe"
    prefix = "terraform/np"
  }
}
