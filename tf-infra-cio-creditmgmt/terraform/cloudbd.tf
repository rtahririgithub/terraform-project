module "cloudsql_new" {
  source            = "git::ssh://git@github.com/telus/tf-module-gcp-cloudsql.git?ref=v0.3.1%2Btf.0.13.3"
  project_id        = var.project_id
  region            = var.region
  db_server_name    = var.db_server_name_new
  db_name           = var.db_name
  db_version        = "POSTGRES_14"
  private_network   = var.shared_vpc_network
  availability_type = var.db_zonal_type
  instance_tier     = var.db_instance_tier
  #any instances on which we want to enable IAM Authentication should add: cloudsql.iam_authentication=on
  database_flags = {
    "cloudsql.iam_authentication" : "on"
  }
}

resource "google_sql_user" "users_new" {
  name       = "admin"
  project    = var.project_id
  instance   = module.cloudsql_new.instance_name
  password   = "changeme"
  depends_on = [module.cloudsql_new]
}



#Create a database user based on the SQL Google Service account provisioned in iam.tf as creditmgmt-gsa
resource "google_sql_user" "creditmgmt-gsa-db-user" {
  name            = "creditmgmt-gsa@${var.project_id}.iam"
  project         = var.project_id
  instance        = module.cloudsql_new.instance_name
  type            = "CLOUD_IAM_SERVICE_ACCOUNT"
  depends_on      = [module.cloudsql_new]
  deletion_policy = "ABANDON"
}