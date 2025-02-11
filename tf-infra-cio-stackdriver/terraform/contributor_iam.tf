resource "google_project_iam_member" "cio-stackdriver-editor" {
  #ONLY GRANT THIS ROLE IN NP
  count   = var.env == "np" ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.editor"
  member  = "group:dlcio-stackdriver-editor@telus.com"
}

resource "google_project_iam_member" "cio-stackdriver-secret-version" {
  project = var.project_id
  role    = "roles/secretmanager.secretVersionAdder"
  member  = "group:dlcio-stackdriver-editor@telus.com"
}

resource "google_project_iam_member" "cio-stackdriver-secret-meta-data" {
  project = var.project_id
  role    = "roles/secretmanager.viewer"
  member  = "group:dlcio-stackdriver-editor@telus.com"
}
