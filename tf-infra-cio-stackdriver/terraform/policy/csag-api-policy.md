## CSAG ${api} return ${level} response code
## Please note the alert message in your SMS, phone, or personal's email should be DELETED promptly after the incident has been addressed.
Stackdriver monitoring has detected API error response  
*Error Code: $${metric.label.error_code}
*Container: $${resource.labels.container_name}
*Condition: $${condition.name}
*Condition Name: $${condition.display_name}
*Metric Type: $${metric.type}
*Metric Name: $${metric.display_name}
*Policy: $${policy.name}
*policy Name: $${policy.display_name}
*project: $${project} 
*Resource Project: $${resource.project}
*Resource Type: $${resource.type}
*Service Name: $${metric.label.serviceName}
*Service Name: $${metric.label.api_method}