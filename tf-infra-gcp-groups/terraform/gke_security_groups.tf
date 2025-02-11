locals {

  # multilist
  g2 = [
    for j in concat(var.gke_fileset) : [
      fileset(path.module, j)
    ]
  ]

  filez  = flatten(local.g2)
  groupz = { for i, k in local.filez : k => jsondecode(file(format("${path.module}/%s", local.filez[i]))) }

}

resource "google_cloud_identity_group" "gke_security_groups" {
  provider     = google-beta
  display_name = "GKE Security Groups"
  parent       = var.parent_id
  group_key {
    id = "gke-security-groups@${var.domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

resource "google_cloud_identity_group_membership" "gke_security_groups_members" {
  provider = google-beta
  for_each = local.groupz
  group    = google_cloud_identity_group.gke_security_groups.id
  preferred_member_key {
    id = "${each.value.id}-ggrp@${var.domain}"
  }

  roles {
    name = "MEMBER"
  }
}

output "filez" {
  value = local.filez
}

output "groupz" {
  value = local.groupz
}

