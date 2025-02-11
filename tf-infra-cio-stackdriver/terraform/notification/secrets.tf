variable "secret_ids" {
  type = map(map(string))
}


resource "google_secret_manager_secret" "secret_ids" {
  project   = var.project_id
  for_each  = var.secret_ids
  secret_id = each.value["secret_id"]

  replication {
    user_managed {
      replicas {
        location = "northamerica-northeast1"
      }
      replicas {
        location = "northamerica-northeast2"
      }
    }
  }
}
