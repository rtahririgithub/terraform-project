## UOM Application receiving error response from API
Stackdriver monitoring has detected API error response  
*Container: $${resource.labels.container_name}  
*Service Call: $${metric.label.service_call}  
*URL: $${metric.label.url}  
*Status: $${metric.label.status}  
*User ID: $${metric.label.userId}  
*Session ID: $${metric.label.sessionId}  
*Client IP: $${metric.label.clientIP}  
*Call ID: $${metric.label.call_id}
## TrueSight Monitoring
```json
{
  "mc_smc_alias":"BMC_Application:Unified_Offer_Manager_TOM",
  "Assignee_Group":"Marketing Offers Applications",
  "msg":"GCP monitor has detected UOM Application receiving 400 or 500 response code from API",
  "severity":"${severity}",
  "mc_host":"uom.cloudapps.telus.com"
}
```
