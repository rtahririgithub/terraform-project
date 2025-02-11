#SOA password
resource "google_secret_manager_secret" "soapassword" {
  project   = var.project_id
  secret_id = "soapassword"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "soapassword-data" {
  secret = google_secret_manager_secret.soapassword.id

  secret_data = "changeme"
}
