# Credit Profile

resource "google_pubsub_topic" "profile_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it02-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "profile_pubsub_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_it02-dl"
}

resource "google_pubsub_subscription" "profile_pubsub_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_qa[1], google_pubsub_topic.profile_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it02-sub"
  topic                   = google_pubsub_topic.profile_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.profile_pubsub_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "profile_pubsub_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_it02-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "profile_pubsub_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.profile_pubsub_qa-sub[count.index].project
  subscription = google_pubsub_subscription.profile_pubsub_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.profile_pubsub_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "profile_pubsub_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}

# Assessment pubSub

resource "google_pubsub_topic" "assessment_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_it02-tp"
}

resource "google_pubsub_topic" "assessment_pubsub_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_it02-dl"
}

resource "google_pubsub_subscription" "last_assessment_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_qa[1], google_pubsub_topic.assessment_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_it02-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.assessment_pubsub_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "last_assessment_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_it02-dl-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "last_assessment_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.last_assessment_qa-sub[count.index].project
  subscription = google_pubsub_subscription.last_assessment_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.last_assessment_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "last_assessment_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.assessment_pubsub_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.assessment_pubsub_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.assessment_pubsub_dead_letter_qa[1]]
}

# X_CONV_START
resource "google_pubsub_topic" "xconv_start_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "xconv_start_it02-tp"
}

resource "google_pubsub_subscription" "xconv_start_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_start_pubsub_qa[1]]
  project                 = var.project_id
  name                    = "xconv_start_it02-sub"
  topic                   = google_pubsub_topic.xconv_start_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# X_CONV_ASMT_START
resource "google_pubsub_topic" "xconv_asmt_start_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "xconv_asmt_start_it02-tp"
}

resource "google_pubsub_subscription" "xconv_asmt_start_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_asmt_start_pubsub_qa[1]]
  project                 = var.project_id
  name                    = "xconv_asmt_start_it02-sub"
  topic                   = google_pubsub_topic.xconv_asmt_start_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# X_CONV_CUST_TO_PROCESS
resource "google_pubsub_topic" "xconv_cust_to_process_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_it02-tp"
}

resource "google_pubsub_topic" "xconv_cust_to_process_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_it02-dl"
}

resource "google_pubsub_subscription" "x_conv_cust_to_process_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_pubsub_qa[1], google_pubsub_topic.xconv_cust_to_process_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_it02-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 600
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.xconv_cust_to_process_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "x_conv_cust_to_process_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_it02-dl-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "x_conv_cust_to_process_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.x_conv_cust_to_process_qa-sub[count.index].project
  subscription = google_pubsub_subscription.x_conv_cust_to_process_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.x_conv_cust_to_process_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "x_conv_cust_to_process_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.xconv_cust_to_process_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.xconv_cust_to_process_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.xconv_cust_to_process_dead_letter_qa[1]]
}

# NoSQL CreditProfileDoc Sync
resource "google_pubsub_topic" "cp_doc_sync_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_it02-tp"
}

resource "google_pubsub_topic" "cp_doc_sync_pubsub_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_it02-dl"
}

resource "google_pubsub_subscription" "cp_doc_sync_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_qa[1], google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_it02-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "cp_doc_sync_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_it02-dl-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_doc_sync_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_doc_sync_qa-sub[count.index].project
  subscription = google_pubsub_subscription.cp_doc_sync_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_doc_sync_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_doc_sync_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_qa[1]]
}

# NoSQL Audit Sync
resource "google_pubsub_topic" "cp_audit_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_it02-tp"
}

resource "google_pubsub_topic" "cp_audit_pubsub_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_it02-dl"
}

resource "google_pubsub_subscription" "cp_audit_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_qa[1], google_pubsub_topic.cp_audit_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_it02-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_pubsub_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_it02-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_qa-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_pubsub_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.cp_audit_pubsub_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_pubsub_dead_letter_qa[1]]
}

# NoSQL Account Sync
resource "google_pubsub_topic" "account_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_it02-tp"
}

resource "google_pubsub_topic" "account_pubsub_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_it02-dl"
}

resource "google_pubsub_subscription" "account_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_qa[1], google_pubsub_topic.account_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "account_v1.0_it02-sub"
  topic                   = google_pubsub_topic.account_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.account_pubsub_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "account_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "account_v1.0_it02-dl-sub"
  topic                   = google_pubsub_topic.account_pubsub_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "account_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.account_qa-sub[count.index].project
  subscription = google_pubsub_subscription.account_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.account_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "account_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.account_pubsub_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.account_pubsub_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.account_pubsub_dead_letter_qa[1]]
}

# NoSQL CreditChange
resource "google_pubsub_topic" "creditchange_pubsub_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_it02-tp"
}

resource "google_pubsub_topic" "creditchange_pubsub_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_it02-dl"
}

resource "google_pubsub_subscription" "creditchange_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_qa[1], google_pubsub_topic.creditchange_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_it02-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.creditchange_pubsub_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "creditchange_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_it02-dl-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "creditchange_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.creditchange_qa-sub[count.index].project
  subscription = google_pubsub_subscription.creditchange_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.creditchange_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "creditchange_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.creditchange_pubsub_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.creditchange_pubsub_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.creditchange_pubsub_dead_letter_qa[1]]
}

# CP Audit Purge IT02

resource "google_pubsub_topic" "cp_audit_purge_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_it02-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "cp_audit_purge_dead_letter_qa" {
  count   = (var.env == "np") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_it02-dl"
}

resource "google_pubsub_subscription" "cp_audit_purge_qa-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_qa[1], google_pubsub_topic.cp_audit_purge_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_it02-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_purge_dead_letter_qa[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_purge_qa-dl-sub" {
  count                   = (var.env == "np") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_dead_letter_qa[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_it02-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_dead_letter_qa[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_purge_qa-role-sub" {
  count        = (var.env == "np") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_purge_qa-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_purge_qa-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_purge_qa-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_purge_qa-role-pub" {
  count      = (var.env == "np") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_purge_dead_letter_qa[count.index].project
  topic      = google_pubsub_topic.cp_audit_purge_dead_letter_qa[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_purge_dead_letter_qa[1]]
}