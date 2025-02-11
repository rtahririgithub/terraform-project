# ITSM (and TCC) Integration

## Introduction.
The CloudCoE and the Data Centre Monitoring team have developed a mechanism for routing alerts from GCP to on premise monitoring tools. The guiding principle is that data will not be duplicated to on-premise systems, but a mechanism will be provided to indicate to support teams that they must investigate an issue in GCP, by creating an Incident in [ITSM Enterprise](https://go.telus.com/itsm). Once an Incident is created, the [TELUS Command Centre (TCC)](https://go.telus.com/tcc) can be involved if procedures have been agreed-to and set up with the TCC ahead of time.

## Prerequisites
In order to use this solution, an application must:
+ Have CI(s) defined in [CMDB](https://go.telus.com/itsm)
+ These CI(s) must be associated with an ITSM Support group.
+ The notification policy must include the channel `TrueSight Incident Receiver`
+ The notification policy's `documentation content` attribute must be formatted to meet the established format. 

> Discussion of CMDB and CIs is outside of the scope of the document.
> See [Google Cloud Monitoring Integration with TrueSight and ITSM](https://watchtower.tsl.telus.com/docs/bin/view/Main/Service%20Catalog/Event%20Integrations/Google%20Cloud%20Monitoring%20Integration%20with%20TrueSight%20and%20ITSM/)
> for more details.

### Notification Channel

A data block must be used to retrieve details about the notification channel that the incident receiver is polling. 

``` terraform
data "google_monitoring_notification_channel" "TrueSight" {
  display_name = "TrueSight Incident Receiver"
  project      = var.project_id
}
```
This notification channel is anticipated to be used by multiple projects, and as such is already established in [`common-channels.tf`](terraform/policy/common-channels).  The channel must be added to the attribute `notif_id` in the policy that is established:

```terraform
module "alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = var.policy_display_name
  notif_id = [
    data.google_monitoring_notification_channel.TrueSight.name,
  ]
  enabled              = var.enable_notification
  content              = local.content
}
```

### Content

The content (a.k.a Documentation) of your policy must include a machine readable `json` block as shown in the example below:
````
# My Alert
Alert message. 
Call to action.

## TrueSight Monitoring

```json
{
  "key1":"value1",
  "key2":"value2",
  ...
}
```
````

See [Google Cloud Monitoring Integration with TrueSight and ITSM](https://watchtower.tsl.telus.com/docs/bin/view/Main/Service%20Catalog/Event%20Integrations/Google%20Cloud%20Monitoring%20Integration%20with%20TrueSight%20and%20ITSM/)
for details of the key-value pairs that should be present in the JSON.

The alert policy must reference this in its content block as shown below, where the content is pulled in from a MarkDown (.md) file:

```terraform
locals {
  content = file("${path.module}/interconnect-policy.md")
}

module "alert_policy" {
  source                 = "git::ssh://git@github.com/telus/tf-module-gcp-alert-policy?ref=v0.2.0"
  project                = var.project_id
  alert_display_name     = var.policy_display_name
  notif_id = [
    data.google_monitoring_notification_channel.TrueSight.name,
  ]
  enabled              = var.enable_notification
  content              = local.content
}
```
<!-- Linkage tool -->
<!-- https://watchtower.tsl.telus.com/cgi-bin/dosql/bppm/ci_impacts -->
<!-- https://watchtower.tsl.telus.com/cgi-bin/dosql/bppm/ci_impacts_stg -->
