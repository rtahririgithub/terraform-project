#==================Start merge dv env=================================
#Topic
resource "google_pubsub_topic" "merge_pubsub_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_dv-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "merge_pubsub_dead_letter_dv" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_dv-dl"
}

resource "google_pubsub_subscription" "merge_pubsub_dv-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.merge_pubsub_dv[1], google_pubsub_topic.merge_pubsub_dead_letter_dv[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_dv-sub"
  topic                   = google_pubsub_topic.merge_pubsub_dv[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.merge_pubsub_dead_letter_dv[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "merge_pubsub_dv-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_dv-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "merge_pubsub_dv-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.merge_pubsub_dv-sub[count.index].project
  subscription = google_pubsub_subscription.merge_pubsub_dv-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.merge_pubsub_dv-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "merge_pubsub_dv-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}
#==================End merge dv env=================================
#==================Start merge it01 env=================================
#Topic
resource "google_pubsub_topic" "merge_pubsub_it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it01-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "merge_pubsub_dead_letter_it01" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it01-dl"
}

resource "google_pubsub_subscription" "merge_pubsub_it01-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.merge_pubsub_it01[1], google_pubsub_topic.merge_pubsub_dead_letter_it01[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it01-sub"
  topic                   = google_pubsub_topic.merge_pubsub_it01[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.merge_pubsub_dead_letter_it01[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "merge_pubsub_it01-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it01-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "merge_pubsub_it01-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.merge_pubsub_it01-sub[count.index].project
  subscription = google_pubsub_subscription.merge_pubsub_it01-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.merge_pubsub_it01-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "merge_pubsub_it01-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}
#==================End merge it01 env=================================
#==================Start merge it02 env=================================
#Topic
resource "google_pubsub_topic" "merge_pubsub_it02" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it02-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "merge_pubsub_dead_letter_it02" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it02-dl"
}

resource "google_pubsub_subscription" "merge_pubsub_it02-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.merge_pubsub_it02[1], google_pubsub_topic.merge_pubsub_dead_letter_it02[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it02-sub"
  topic                   = google_pubsub_topic.merge_pubsub_it02[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.merge_pubsub_dead_letter_it02[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "merge_pubsub_it02-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it02-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "merge_pubsub_it02-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.merge_pubsub_it02-sub[count.index].project
  subscription = google_pubsub_subscription.merge_pubsub_it02-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.merge_pubsub_it02-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "merge_pubsub_it02-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}
#==================End merge it02 env=================================
#==================Start merge it03 env=================================
#Topic
resource "google_pubsub_topic" "merge_pubsub_it03" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it03-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "merge_pubsub_dead_letter_it03" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it03-dl"
}

resource "google_pubsub_subscription" "merge_pubsub_it03-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.merge_pubsub_it03[1], google_pubsub_topic.merge_pubsub_dead_letter_it03[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it03-sub"
  topic                   = google_pubsub_topic.merge_pubsub_it03[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.merge_pubsub_dead_letter_it03[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "merge_pubsub_it03-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it03-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "merge_pubsub_it03-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.merge_pubsub_it03-sub[count.index].project
  subscription = google_pubsub_subscription.merge_pubsub_it03-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.merge_pubsub_it03-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "merge_pubsub_it03-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}
#==================End merge it03 env=================================
#==================Start merge it04 env=================================
#Topic
resource "google_pubsub_topic" "merge_pubsub_it04" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it04-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "merge_pubsub_dead_letter_it04" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "merge_pubsub_it04-dl"
}

resource "google_pubsub_subscription" "merge_pubsub_it04-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.merge_pubsub_it04[1], google_pubsub_topic.merge_pubsub_dead_letter_it04[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it04-sub"
  topic                   = google_pubsub_topic.merge_pubsub_it04[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.merge_pubsub_dead_letter_it04[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "merge_pubsub_it04-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
  project                 = var.project_id
  name                    = "merge_pubsub_it04-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "merge_pubsub_it04-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.merge_pubsub_it04-sub[count.index].project
  subscription = google_pubsub_subscription.merge_pubsub_it04-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.merge_pubsub_it04-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "merge_pubsub_it04-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}
#==================End merge it04 env=================================
