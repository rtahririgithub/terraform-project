env = "pr"

project_id = "gcp-groups-pr-c6c009"

project_name = "gcp-groups-pr"

project_number = "708509601909"

region = "northamerica-northeast1"

organization_id = "637987714668"

parent_id = "customers/C02g1zc2t"

domain = "telus.com"

fileset = [
  "cloud_coe/*.json",
  "cso/*.json",
  "adhoc/*.json",
  "cloud_monitoring/*.json",
  "gcp/dstq/*.json",
  "bi_layer/*.json",
  "gidc/*.json",
  "frictionless-opus/*.json",
  "orbit/*.json",
  "kuleana/*.json",
  "gcp/oracle-media/*.json"
]

gke_fileset = [
  "gke/*.json"
]

gcp_group_management_sa_token_creators = [
  "serviceAccount:k8s-onboarding-app-svc-acct@cio-cloud-project-mgmt-pr-17c7.iam.gserviceaccount.com",
  "serviceAccount:k8s-onboarding-app-svc-acct@cio-cloud-project-mgmt-np-b23f.iam.gserviceaccount.com",
  "serviceAccount:firebase-adminsdk-vcn9f@cio-cloud-project-mgmt-np-b23f.iam.gserviceaccount.com",
  "serviceAccount:121528596659@cloudbuild.gserviceaccount.com" ## factory cloud build sa
]

git_ops_account_id = "gitops-sa"
