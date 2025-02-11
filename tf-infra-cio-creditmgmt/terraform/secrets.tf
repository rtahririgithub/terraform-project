#DB password
resource "google_secret_manager_secret" "db-password" {
  project   = var.project_id
  secret_id = "db-password"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "db-password-data" {
  secret = google_secret_manager_secret.db-password.id

  secret_data = "changeme"
}

# IT03
resource "google_secret_manager_secret" "db-password-testing" {
  count     = (var.env == "np") ? 1 : 0
  project   = var.project_id
  secret_id = "db-password-it03"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "db-password-data-testing" {
  count  = (var.env == "np") ? 1 : 0
  secret = google_secret_manager_secret.db-password-testing[count.index].id

  secret_data = "changeme"
}

# IT04
resource "google_secret_manager_secret" "db-password-staging" {
  count     = (var.env == "np") ? 1 : 0
  project   = var.project_id
  secret_id = "db-password-it04"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "db-password-data-staging" {
  count  = (var.env == "np") ? 1 : 0
  secret = google_secret_manager_secret.db-password-staging[count.index].id

  secret_data = "changeme"
}

# crypto
resource "google_secret_manager_secret" "crypto-key" {
  project   = var.project_id
  secret_id = "crypto-key"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "crypto-key-data" {
  secret = google_secret_manager_secret.crypto-key.id

  secret_data = "changeme"
}

resource "google_secret_manager_secret" "crypto-password" {
  project   = var.project_id
  secret_id = "crypto-password"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "crypto-password-data" {
  secret = google_secret_manager_secret.crypto-password.id

  secret_data = "changeme"
}

resource "google_secret_manager_secret" "crypto-key1" {
  project   = var.project_id
  secret_id = "crypto-key1"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "crypto-key1-data" {
  secret = google_secret_manager_secret.crypto-key1.id

  secret_data = "changeme"
}

resource "google_secret_manager_secret" "crypto-key2" {
  project   = var.project_id
  secret_id = "crypto-key2"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "crypto-key2-data" {
  secret = google_secret_manager_secret.crypto-key2.id

  secret_data = "changeme"
}

resource "google_secret_manager_secret" "crypto-key3" {
  project   = var.project_id
  secret_id = "crypto-key3"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "crypto-key3-data" {
  secret = google_secret_manager_secret.crypto-key3.id

  secret_data = "changeme"
}

resource "google_secret_manager_secret" "crypto-keystore-file" {
  project   = var.project_id
  secret_id = "crypto-keystore-file"

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "tfm-keystore" {
  project   = var.project_id
  secret_id = "tfm-keystore"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "crypto-keystore-file-data" {
  secret = google_secret_manager_secret.crypto-keystore-file.id

  secret_data = "changeme"
}

#AFM password
resource "google_secret_manager_secret" "afm-password" {
  project   = var.project_id
  secret_id = "afm-password"

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "afm-password-data" {
  secret = google_secret_manager_secret.afm-password.id

  secret_data = "changeme"
}



#fraudPrediction password
resource "google_secret_manager_secret" "fraudPrediction-password" {
  project   = var.project_id
  secret_id = "fraudPrediction-password"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "fraudPrediction-password-data" {
  secret = google_secret_manager_secret.fraudPrediction-password.id

  secret_data = "changeme"
}

# wlscrdmgtdbpswd-dev
resource "google_secret_manager_secret" "wlscrdmgtdbpswd-dev" {
  count     = (var.env == "np") ? 1 : 0
  project   = var.project_id
  secret_id = "wlscrdmgtdbpswd-dev"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "wlscrdmgtdbpswd-dev" {
  count  = (var.env == "np") ? 1 : 0
  secret = google_secret_manager_secret.wlscrdmgtdbpswd-dev[count.index].id
  secret_data = "changeme"
}
# wlscrdmgtdbpswd-it01
resource "google_secret_manager_secret" "wlscrdmgtdbpswd-it01" {
  count     = (var.env == "np") ? 1 : 0
  project   = var.project_id
  secret_id = "wlscrdmgtdbpswd-it01"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "wlscrdmgtdbpswd-it01" {
  count  = (var.env == "np") ? 1 : 0
  secret = google_secret_manager_secret.wlscrdmgtdbpswd-it01[count.index].id
  secret_data = "changeme"
}
# wlscrdmgtdbpswd-it02
resource "google_secret_manager_secret" "wlscrdmgtdbpswd-it02" {
  count     = (var.env == "np") ? 1 : 0
  project   = var.project_id
  secret_id = "wlscrdmgtdbpswd-it02"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "wlscrdmgtdbpswd-it02" {
  count  = (var.env == "np") ? 1 : 0
  secret = google_secret_manager_secret.wlscrdmgtdbpswd-it02[count.index].id
  secret_data = "changeme"
}
# wlscrdmgtdbpswd-it03
resource "google_secret_manager_secret" "wlscrdmgtdbpswd-it03" {
  count     = (var.env == "np") ? 1 : 0
  project   = var.project_id
  secret_id = "wlscrdmgtdbpswd-it03"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "wlscrdmgtdbpswd-it03" {
  count  = (var.env == "np") ? 1 : 0
  secret = google_secret_manager_secret.wlscrdmgtdbpswd-it03[count.index].id
  secret_data = "changeme"
}
# wlscrdmgtdbpswd-it04
resource "google_secret_manager_secret" "wlscrdmgtdbpswd-it04" {
  count     = (var.env == "np") ? 1 : 0
  project   = var.project_id
  secret_id = "wlscrdmgtdbpswd-it04"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "wlscrdmgtdbpswd-it04" {
  count  = (var.env == "np") ? 1 : 0
  secret = google_secret_manager_secret.wlscrdmgtdbpswd-it04[count.index].id
  secret_data = "changeme"
}

#wlscrdmgtdbpswd-pr
resource "google_secret_manager_secret" "wlscrdmgtdbpswd-pr" {
  project   = var.project_id
  secret_id = "wlscrdmgtdbpswd-pr"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "wlscrdmgtdbpswd-pr-data" {
  secret = google_secret_manager_secret.wlscrdmgtdbpswd-pr.id
  secret_data = "changeme"
}