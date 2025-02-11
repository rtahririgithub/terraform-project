terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"

    }
    google = {
      source  = "hashicorp/google"
      version = ">=3.61.0"
    }
    google-tokengen = {
      source  = "hashicorp/google"
      version = ">=3.61.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">=3.61.0"
    }

  }
}

provider "google-beta" {
  access_token          = data.google_service_account_access_token.sa.access_token
  user_project_override = true
  billing_project       = "gcp-groups-pr-c6c009"
}


data "google_service_account_access_token" "sa" {
  provider               = google-tokengen
  target_service_account = module.service_account.email
  lifetime               = "600s"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform", "https://www.googleapis.com/auth/cloud-identity.groups", "https://www.googleapis.com/auth/cloud-identity"
  ]
}
