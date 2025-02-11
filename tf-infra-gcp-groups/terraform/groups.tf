locals {

  # multilist
  f2 = [
    for j in concat(var.fileset, var.gke_fileset) : [
      fileset(path.module, j)
    ]
  ]

  files  = flatten(local.f2)
  groups = { for i, k in local.files : k => jsondecode(file(format("${path.module}/%s", local.files[i]))) }

  #Get the list of members
  zip_member_list = flatten([
    for key, group in local.groups : [
      for member in group.members : [member]
    ]
  ])

  #Get the list of groups. Build composite key
  zip_member_group_list = flatten([
    for key, group in local.groups : [
      for group in group.members : [
        format("%s|%s", key, group)
      ]
    ]
  ])

  #Build Zip Map
  member_zip_map = zipmap(local.zip_member_group_list, local.zip_member_list)

  #Get the list of owners
  zip_owner_list = flatten([
    for key, group in local.groups : [
      for owner in group.owners : [owner]
    ]
  ])

  #Get the list of groups. Build composite key
  zip_owner_group_list = flatten([
    for key, group in local.groups : [
      for group in group.owners : [
        format("%s|%s", key, group)
      ]
    ]
  ])

  #Build the zip map
  owner_zip_map = zipmap(local.zip_owner_group_list, local.zip_owner_list)

  #Get the list of managers
  zip_manager_list = flatten([
    for key, group in local.groups : [
      for manager in group.managers : [manager]
    ]
  ])


  #Get the list of managers. Build composite key
  zip_manager_group_list = flatten([
    for key, group in local.groups : [
      for group in group.managers : [
        format("%s|%s", key, group)
      ]
    ]
  ])
  #Build the zip map
  manager_zip_map = zipmap(local.zip_manager_group_list, local.zip_manager_list)
}


resource "google_cloud_identity_group" "groups" {
  provider     = google-beta
  for_each     = local.groups
  display_name = each.value.displayName
  parent       = var.parent_id
  group_key {
    id = "${each.value.id}-ggrp@${var.domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}

resource "google_cloud_identity_group_membership" "owners" {
  provider = google-beta
  for_each = local.owner_zip_map
  group    = google_cloud_identity_group.groups[split("|", each.key)[0]].id
  preferred_member_key {
    id = each.value
  }
  # Order is sensitive for these roles.
  roles {
    name = "OWNER"
  }

  roles {
    name = "MEMBER"
  }
}

resource "google_cloud_identity_group_membership" "managers" {
  provider = google-beta
  for_each = local.manager_zip_map
  group    = google_cloud_identity_group.groups[split("|", each.key)[0]].id
  preferred_member_key {
    id = each.value
  }
  # Order is sensitive for these roles.
  roles {
    name = "MANAGER"
  }

  roles {
    name = "MEMBER"
  }
}

resource "google_cloud_identity_group_membership" "members" {
  provider = google-beta
  for_each = local.member_zip_map
  group    = google_cloud_identity_group.groups[split("|", each.key)[0]].id
  preferred_member_key {
    id = each.value
  }

  roles {
    name = "MEMBER"
  }
}

