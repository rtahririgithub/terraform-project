# Credit Profile

resource "google_pubsub_topic" "profile_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_prd-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "profile_pubsub_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "credit-profile_v1.0_prd-dl"
}

resource "google_pubsub_subscription" "profile_pubsub_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_prd[1], google_pubsub_topic.profile_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_prd-sub"
  topic                   = google_pubsub_topic.profile_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.profile_pubsub_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "profile_pubsub_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.profile_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "credit-profile_v1.0_prd-dl-sub"
  topic                   = google_pubsub_topic.profile_pubsub_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "profile_pubsub_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.profile_pubsub_prd-sub[count.index].project
  subscription = google_pubsub_subscription.profile_pubsub_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.profile_pubsub_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "profile_pubsub_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.profile_pubsub_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.profile_pubsub_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.profile_pubsub_dead_letter[1]]
}

# Assessment pubSub

resource "google_pubsub_topic" "assessment_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_prd-tp"
}

resource "google_pubsub_topic" "assessment_pubsub_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "last-assessment_v1.0_prd-dl"
}

resource "google_pubsub_subscription" "last_assessment_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_prd[1], google_pubsub_topic.assessment_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_prd-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.assessment_pubsub_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "last_assessment_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.assessment_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "last-assessment_v1.0_prd-dl-sub"
  topic                   = google_pubsub_topic.assessment_pubsub_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "last_assessment_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.last_assessment_prd-sub[count.index].project
  subscription = google_pubsub_subscription.last_assessment_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.last_assessment_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "last_assessment_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.assessment_pubsub_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.assessment_pubsub_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.assessment_pubsub_dead_letter_prd[1]]
}

# X_CONV_START
resource "google_pubsub_topic" "xconv_start_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "xconv_start_prd-tp"
}

resource "google_pubsub_subscription" "xconv_start_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_start_pubsub_prd[1]]
  project                 = var.project_id
  name                    = "xconv_start_prd-sub"
  topic                   = google_pubsub_topic.xconv_start_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# X_CONV_ASMT_START
resource "google_pubsub_topic" "xconv_asmt_start_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "xconv_asmt_start_prd-tp"
}

resource "google_pubsub_subscription" "xconv_asmt_start_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_asmt_start_pubsub_prd[1]]
  project                 = var.project_id
  name                    = "xconv_asmt_start_prd-sub"
  topic                   = google_pubsub_topic.xconv_asmt_start_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}

# X_CONV_CUST_TO_PROCESS
resource "google_pubsub_topic" "xconv_cust_to_process_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_prd-tp"
}

resource "google_pubsub_topic" "xconv_cust_to_process_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "x_conv_cust_to_process_prd-dl"
}

resource "google_pubsub_subscription" "x_conv_cust_to_process_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_pubsub_prd[1], google_pubsub_topic.xconv_cust_to_process_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_prd-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 600
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.xconv_cust_to_process_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "x_conv_cust_to_process_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.xconv_cust_to_process_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "x_conv_cust_to_process_prd-dl-sub"
  topic                   = google_pubsub_topic.xconv_cust_to_process_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "x_conv_cust_to_process_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.x_conv_cust_to_process_prd-sub[count.index].project
  subscription = google_pubsub_subscription.x_conv_cust_to_process_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.x_conv_cust_to_process_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "x_conv_cust_to_process_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.xconv_cust_to_process_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.xconv_cust_to_process_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.xconv_cust_to_process_dead_letter_prd[1]]
}

# NoSQL CreditProfileDoc Sync
resource "google_pubsub_topic" "cp_doc_sync_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_prd-tp"
}

resource "google_pubsub_topic" "cp_doc_sync_pubsub_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "cp-doc-sync_v1.0_prd-dl"
}

resource "google_pubsub_subscription" "cp_doc_sync_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_prd[1], google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_prd-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "cp_doc_sync_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "cp-doc-sync_v1.0_prd-dl-sub"
  topic                   = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_doc_sync_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.cp_doc_sync_prd-sub[count.index].project
  subscription = google_pubsub_subscription.cp_doc_sync_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_doc_sync_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_doc_sync_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_doc_sync_pubsub_dead_letter_prd[1]]
}

# NoSQL Audit Sync
resource "google_pubsub_topic" "cp_audit_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_prd-tp"
}

resource "google_pubsub_topic" "cp_audit_pubsub_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "cp-audit_v1.0_prd-dl"
}

resource "google_pubsub_subscription" "cp_audit_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_prd[1], google_pubsub_topic.cp_audit_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_prd-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_pubsub_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "cp-audit_v1.0_prd-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_pubsub_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_prd-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_pubsub_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.cp_audit_pubsub_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_pubsub_dead_letter_prd[1]]
}

# NoSQL Account Sync
resource "google_pubsub_topic" "account_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_prd-tp"
}

resource "google_pubsub_topic" "account_pubsub_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "account_v1.0_prd-dl"
}

resource "google_pubsub_subscription" "account_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_prd[1], google_pubsub_topic.account_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "account_v1.0_prd-sub"
  topic                   = google_pubsub_topic.account_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.account_pubsub_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "account_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.account_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "account_v1.0_prd-dl-sub"
  topic                   = google_pubsub_topic.account_pubsub_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "account_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.account_prd-sub[count.index].project
  subscription = google_pubsub_subscription.account_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.account_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "account_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.account_pubsub_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.account_pubsub_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.account_pubsub_dead_letter_prd[1]]
}

# NoSQL CreditChange
resource "google_pubsub_topic" "creditchange_pubsub_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_prd-tp"
}

resource "google_pubsub_topic" "creditchange_pubsub_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "capi-creditchange_v1.0_prd-dl"
}

resource "google_pubsub_subscription" "creditchange_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_prd[1], google_pubsub_topic.creditchange_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_prd-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.creditchange_pubsub_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}
# dead letter sub
resource "google_pubsub_subscription" "creditchange_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.creditchange_pubsub_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "capi-creditchange_v1.0_prd-dl-sub"
  topic                   = google_pubsub_topic.creditchange_pubsub_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "creditchange_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.creditchange_prd-sub[count.index].project
  subscription = google_pubsub_subscription.creditchange_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.creditchange_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "creditchange_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.creditchange_pubsub_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.creditchange_pubsub_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.creditchange_pubsub_dead_letter_prd[1]]
}

# CP Audit Purge prd

resource "google_pubsub_topic" "cp_audit_purge_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_prd-tp"
}

#Dead letter Topic
resource "google_pubsub_topic" "cp_audit_purge_dead_letter_prd" {
  count   = (var.env == "pr") ? 1 : 0
  project = var.project_id
  name    = "cp-audit-purge-start_v1.0_prd-dl"
}

resource "google_pubsub_subscription" "cp_audit_purge_prd-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_prd[1], google_pubsub_topic.cp_audit_purge_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_prd-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.cp_audit_purge_dead_letter_prd[count.index].id
    max_delivery_attempts = 5
  }
}

# dead letter sub
resource "google_pubsub_subscription" "cp_audit_purge_prd-dl-sub" {
  count                   = (var.env == "pr") ? 1 : 0
  depends_on              = [google_pubsub_topic.cp_audit_purge_dead_letter_prd[1]]
  project                 = var.project_id
  name                    = "cp-audit-purge-start_v1.0_prd-dl-sub"
  topic                   = google_pubsub_topic.cp_audit_purge_dead_letter_prd[count.index].name
  retain_acked_messages   = false
  ack_deadline_seconds    = 20
  enable_message_ordering = false
  expiration_policy {
    ttl = ""
  }
}
# dead letter topic additional permission with pubsub default account
resource "google_pubsub_subscription_iam_member" "cp_audit_purge_prd-role-sub" {
  count        = (var.env == "pr") ? 1 : 0
  project      = google_pubsub_subscription.cp_audit_purge_prd-sub[count.index].project
  subscription = google_pubsub_subscription.cp_audit_purge_prd-sub[count.index].name
  role         = "roles/pubsub.subscriber"
  member       = "serviceAccount:${var.pubsub_default_account}"
  depends_on   = [google_pubsub_subscription.cp_audit_purge_prd-sub[1]]
}

# dead letter topic additional permission with pubsub default account
resource "google_pubsub_topic_iam_member" "cp_audit_purge_prd-role-pub" {
  count      = (var.env == "pr") ? 1 : 0
  project    = google_pubsub_topic.cp_audit_purge_dead_letter_prd[count.index].project
  topic      = google_pubsub_topic.cp_audit_purge_dead_letter_prd[count.index].name
  role       = "roles/pubsub.publisher"
  member     = "serviceAccount:${var.pubsub_default_account}"
  depends_on = [google_pubsub_topic.cp_audit_purge_dead_letter_prd[1]]
}