datahub_projects = {
  landing    = "cio-datahub-landing-qa-d2c35b"
  work       = "cio-datahub-work-qa-1e9ecf"
  enterprise = "cio-datahub-enterprise-qa-ecf3"
  control    = "cio-datahub-control-qa-fd868f"
}

bq_sla_metric             = "logging.googleapis.com/user/cio-datahub-work-qa-1e9ecf_bq_load_monitor"
sre_sla_check             = "logging.googleapis.com/user/cio-datahub-work-qa-1e9ecf_sre_sla_check"
sre_job_performance_check = "logging.googleapis.com/user/cio-datahub-work-qa-1e9ecf_sre_job_performance_check"
sre_latency               = "logging.googleapis.com/user/cio-datahub-work-qa-1e9ecf_sre_latency"
user_define_check         = "logging.googleapis.com/user/cio-datahub-work-qa-1e9ecf_user_define_check"

datahub_enable_notification = true
